//
//  BFCollectionViewLayout.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFCollectionViewLayout.h"

/**
 * Default number of visible items.
 */
static NSUInteger const defaultNumOfItems      = 2;
/**
 * Default minimum spacing to use between items in the same row.
 */
static CGFloat const defaultInteritemSpacing   = 15.0;
/**
 * Default minimum spacing to use between lines of items in the grid.
 */
static CGFloat const defaultMinimumLineSpacing = 15.0;
/**
 * Default percentage of item size in comparison with available height.
 */
static CGFloat const defaultHeightResizeRatio    = 1.0;
/**
 * Default percentage of item size in comparison with available width.
 */
static CGFloat const defaultWidthResizeRatio    = 1.0;
/**
 * Default section margins.
 */
static CGFloat const defaultSectionTopInset    = 10.0;
static CGFloat const defaultSectionRightInset  = 10.0;
static CGFloat const defaultSectionLeftInset   = 10.0;
static CGFloat const defaultSectionBottomInset = 10.0;
/**
 * Default item size.
 */
static CGFloat const defaultItemWidth          = 280.0;
static CGFloat const defaultItemHeight         = 280.0;


@interface BFCollectionViewLayout ()

/**
 * Inserted collection view sections during the content updates.
 */
@property (nonatomic, strong) NSMutableArray *insertedSections;
/**
 * Removed collection view sections during the content updates.
 */
@property (nonatomic, strong) NSMutableArray *removedSections;
/**
 * Reloaded collection view sections during the content updates.
 */
@property (nonatomic, strong) NSMutableArray *reloadedSections;

/**
 * Current collection view cell attributes.
 */
@property (nonatomic, strong) NSMutableDictionary *currentCellAttributes;
/**
 * Current collection view cell suplementary view attributes.
 */
@property (nonatomic, strong) NSMutableDictionary *currentSupplementaryAttributesByKind;
/**
 * Cached collection view cell attributes.
 */
@property (nonatomic, strong) NSMutableDictionary *cachedCellAttributes;
/**
 * Cached collection view cell suplementary view attributes.
 */
@property (nonatomic, strong) NSMutableDictionary *cachedSupplementaryAttributesByKind;

/**
 * Returns index path for previous location of collection view cells when cells get removed or inserted.
 *
 * @param indexPath The collection view cell current index path.
 * @return The previous index path for collection view cell at specified index path.
 */
- (NSIndexPath*)previousIndexPathForIndexPath:(NSIndexPath*)indexPath;

@end
    

@implementation BFCollectionViewLayout


#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        // current layout attributes
        self.currentCellAttributes = [NSMutableDictionary dictionary];
        self.currentSupplementaryAttributesByKind = [NSMutableDictionary dictionary];
        // set defaults
        [self setDefaultAttributes];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        // set defaults
        [self setDefaultAttributes];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setDefaultAttributes {
    // items spacing
    self.minimumInteritemSpacing = defaultInteritemSpacing;
    self.minimumLineSpacing = defaultMinimumLineSpacing;
    // scroll direction
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    // margins
    self.sectionInset = UIEdgeInsetsMake(defaultSectionTopInset, defaultSectionLeftInset, defaultSectionBottomInset, defaultSectionRightInset);
    // item size
    self.itemSize = CGSizeMake(defaultItemWidth, defaultItemHeight);
    // header size
    self.headerReferenceSize = CGSizeZero;
    // footer size
    self.footerReferenceSize = CGSizeZero;
    // number of items
    _numOfItems = defaultNumOfItems;
    // resize ratio
    _heightResizeRatio = defaultHeightResizeRatio;
    _widthResizeRatio = defaultWidthResizeRatio;
    // maximum item size
    _maxItemSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
}


#pragma mark - Custom Initialization

- (id)initWithNumOfItems:(NSUInteger)numOfItems {
    return [self initWithNumOfItems:numOfItems maxItemSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) heightResizeRatio:defaultHeightResizeRatio widthResizeRatio:defaultWidthResizeRatio];
}

- (id)initWithNumOfItems:(NSUInteger)numOfItems maxItemSize:(CGSize)maxItemSize {
    return [self initWithNumOfItems:numOfItems maxItemSize:maxItemSize heightResizeRatio:defaultHeightResizeRatio widthResizeRatio:defaultWidthResizeRatio];
}

- (id)initWithNumOfItems:(NSUInteger)numOfItems maxItemSize:(CGSize)maxItemSize heightResizeRatio:(CGFloat)heightResizeRatio widthResizeRatio:(CGFloat)widthResizeRatio {
    self = [super init];
    if (self) {
        // set defaults
        [self setDefaultAttributes];
        // resize ratio
        _heightResizeRatio = heightResizeRatio;
        _widthResizeRatio = widthResizeRatio;
        // number of items
        _numOfItems = numOfItems;
        // maximum item size
        _maxItemSize = maxItemSize;
    }
    return self;
}


#pragma mark - Properties Setters

- (void)setNumOfItems:(NSUInteger)numOfItems {
    _numOfItems = numOfItems;
    [self invalidateLayout];
}

- (void)setHeightResizeRatio:(CGFloat)heightResizeRatio {
    _heightResizeRatio = heightResizeRatio;
    [self invalidateLayout];
}

- (void)setWidthResizeRatio:(CGFloat)widthResizeRatio {
    _widthResizeRatio = widthResizeRatio;
    [self invalidateLayout];
}

- (void)setMaxItemSize:(CGSize)maxItemSize {
    _maxItemSize = maxItemSize;
    [self invalidateLayout];
}


#pragma mark - Item Size Calculation

- (CGSize)itemSizeInCollectionView:(UICollectionView *)collectionView {
    if(_numOfItems > 0) {
        // collection view size
        CGFloat collectionViewWidth = collectionView.frame.size.width;
        CGFloat collectionViewHeight = collectionView.frame.size.height;
        // grid size
        NSUInteger numOfColumns;
        NSUInteger numOfRows;
        // row items calculation
        double numOfLineItems = sqrt(_numOfItems);
        if([@(numOfLineItems*numOfLineItems)isEqualToNumber:@(_numOfItems)]) {
            numOfColumns = (NSUInteger)numOfLineItems;
            numOfRows = numOfColumns;
        }
        else {
            numOfColumns = floor(numOfLineItems);
            numOfRows = ceil(_numOfItems/numOfColumns);
        }
        
        // item size calculation
        CGFloat itemWidth = ({
                CGFloat totalSpacing = self.sectionInset.left + self.sectionInset.right + (self.minimumInteritemSpacing * (numOfColumns - 1));
                CGFloat itemWidth = (collectionViewWidth - totalSpacing) / numOfColumns;
                itemWidth * _widthResizeRatio;
            });
        CGFloat itemHeight = ({
            CGFloat totalSpacing = self.sectionInset.top + self.sectionInset.bottom + (self.minimumLineSpacing * (numOfRows - 1));
            CGFloat itemHeight = (collectionViewHeight - totalSpacing) / numOfRows;
            itemHeight * _heightResizeRatio;
        });
        
        return CGSizeMake(MIN(itemWidth, _maxItemSize.width), MIN(itemHeight, _maxItemSize.height));
    }
    return CGSizeZero;
}


#pragma mark - Layout attributes

- (void)prepareLayout {
    [super prepareLayout];
    
    // deep copy of cached attributes
    self.cachedCellAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.currentCellAttributes copyItems:YES];
    // cache supplementary view attributes
    self.cachedSupplementaryAttributesByKind = [NSMutableDictionary dictionary];
    [self.currentSupplementaryAttributesByKind enumerateKeysAndObjectsUsingBlock:^(NSString *kind, NSMutableDictionary *attributeByPath, BOOL *stop) {
        NSMutableDictionary *cachedAttributeByPath = [[NSMutableDictionary alloc] initWithDictionary:attributeByPath copyItems:YES];
        [self.cachedSupplementaryAttributesByKind setObject:cachedAttributeByPath forKey:kind];
    }];
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    // cache all visible attributes to use them for final/initial animation attributes
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        // cell attributes
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            [self.currentCellAttributes setObject:attributes forKey:attributes.indexPath];
        }
        // supplementary view attributes
        else if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView) {
            NSString *elementKind = attributes.representedElementKind;
            NSMutableDictionary *supplementaryAttributesByIndexPath = [self.currentSupplementaryAttributesByKind objectForKey:elementKind];
            if (!supplementaryAttributesByIndexPath) {
                // save attributes for supplementary view of given kind
                supplementaryAttributesByIndexPath = [NSMutableDictionary dictionary];
                [self.currentSupplementaryAttributesByKind setObject:supplementaryAttributesByIndexPath forKey:elementKind];
            }
            [supplementaryAttributesByIndexPath setObject:attributes forKey:attributes.indexPath];
        }
    }];
    
    return attributes;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];

    // track all inserted, deleted or reloaded sections
    self.insertedSections = [NSMutableArray array];
    self.removedSections  = [NSMutableArray array];
    self.reloadedSections  = [NSMutableArray array];
        
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
        // inserted section
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            // section update
            if (updateItem.indexPathAfterUpdate.item == NSNotFound) {
                [self.insertedSections addObject:@(updateItem.indexPathAfterUpdate.section)];
            }
        }
        // deleted section
        else if (updateItem.updateAction == UICollectionUpdateActionDelete) {
            // section update
            if (updateItem.indexPathBeforeUpdate.item == NSNotFound) {
                [self.removedSections addObject:@(updateItem.indexPathBeforeUpdate.section)];
            }
        }
        // reloaded section
        else if (updateItem.updateAction == UICollectionUpdateActionReload) {
            // section update
            if (updateItem.indexPathBeforeUpdate.item == NSNotFound) {
                [self.reloadedSections addObject:@(updateItem.indexPathBeforeUpdate.section)];
            }
        }
    }];
}

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];

    // inserted section
    if ([self.insertedSections containsObject:@(itemIndexPath.section)]) {
        attributes = [[self.currentCellAttributes objectForKey:itemIndexPath] copy];
        /*
         * Initial attributes customization.
         */
    }
    // reloaded section
    else if ([self.reloadedSections containsObject:@(itemIndexPath.section)]) {
        attributes = [[self.currentCellAttributes objectForKey:itemIndexPath] copy];
        /*
         * Initial attributes customization.
         */
    }

    return attributes;
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    // removed section
    if ([self.removedSections containsObject:@(itemIndexPath.section)]) {
        attributes = [[self.cachedCellAttributes objectForKey:itemIndexPath] copy];
        /*
         * Final attributes customization.
         */
    }
    // reloaded section
    else if ([self.reloadedSections containsObject:@(itemIndexPath.section)]) {
        attributes = [[self.cachedCellAttributes objectForKey:itemIndexPath] copy];
        /*
         * Final attributes customization.
         */
    }

    return attributes;
}

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    UICollectionViewLayoutAttributes *attributes;
    
    // inserted section with supplementary view
    if ([self.insertedSections containsObject:@(elementIndexPath.section)]) {
        attributes = [[[self.currentSupplementaryAttributesByKind objectForKey:elementKind] objectForKey:elementIndexPath] copy];
    }
    else {
        // set cached attributes to prevent random positioning
        NSIndexPath *prevPath = [self previousIndexPathForIndexPath:elementIndexPath];
        attributes = [[[self.cachedSupplementaryAttributesByKind objectForKey:elementKind] objectForKey:prevPath] copy];
    }
    
    return attributes;
}


- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    UICollectionViewLayoutAttributes *attributes;
    
    // removed section with supplementary view
    if ([self.removedSections containsObject:@(elementIndexPath.section)]) {
        attributes = [[[self.cachedSupplementaryAttributesByKind objectForKey:elementKind] objectForKey:elementIndexPath] copy];
    }
    else {
        // set current attributes to prevent random positioning
        attributes = [[[self.currentCellAttributes objectForKey:elementKind] objectForKey:elementIndexPath] copy];
    }

    return attributes;
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    self.insertedSections = nil;
    self.removedSections = nil;
    self.reloadedSections = nil;
}


#pragma mark - Layout Attributes Helpers

- (NSIndexPath*)previousIndexPathForIndexPath:(NSIndexPath *)indexPath {
    __block NSInteger section = indexPath.section;
    __block NSInteger item = indexPath.item;
    
    [self.removedSections enumerateObjectsUsingBlock:^(NSNumber *rmSectionIdx, NSUInteger idx, BOOL *stop) {
        // removed section index is lower than the current section
        if ([rmSectionIdx integerValue] <= indexPath.section) {
            section++;
        }
    }];
    
    [self.insertedSections enumerateObjectsUsingBlock:^(NSNumber *insSectionIdx, NSUInteger idx, BOOL *stop) {
        // inserted section index is lower than the current section
        if ([insSectionIdx integerValue] < indexPath.section) {
            section--;
        }
    }];
    
    return [NSIndexPath indexPathForItem:item inSection:section];
}



@end
