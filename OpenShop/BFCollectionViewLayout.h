//
//  BFCollectionViewLayout.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN


/**
 * `BFCollectionViewLayout` is a base collection view flow layout. It contains support
 * for collection view items animation and auto initialization methods.
 */
@interface BFCollectionViewLayout : UICollectionViewFlowLayout

/**
 * Creates a collection view layout with specified number of visible items, maximum item size and item resize ratio.
 *
 * @param numOfItems The number of visible items.
 * @param maxItemSize The maximum item size.
 * @param resizeRatio The item resize ratio.
 * @return The newly-initialized `BFCollectionViewLayout`.
 */
- (id)initWithNumOfItems:(NSUInteger)numOfItems maxItemSize:(CGSize)maxItemSize resizeRatio:(CGFloat)resizeRatio;
/**
 * Creates a collection view layout with specified number of visible items and maximum item size.
 *
 * @param numOfItems The number of visible items.
 * @param maxItemSize The maximum item size.
 * @return The newly-initialized `BFCollectionViewLayout`.
 */
- (id)initWithNumOfItems:(NSUInteger)numOfItems maxItemSize:(CGSize)maxItemSize;

/**
 * Creates a collection view layout with specified number of visible items.
 *
 * @param numOfItems The number of visible items.
 * @return The newly-initialized `BFCollectionViewLayout`.
 */
- (id)initWithNumOfItems:(NSUInteger)numOfItems;

/**
 * Returns calculated item size in the collection view with respect to the layout properties.
 *
 * @param collectionView The collection view.
 * @return The collection view item size.
 */
- (CGSize)itemSizeInCollectionView:(UICollectionView *)collectionView;


/**
 * Percentage of item size in comparison with available space (0.0f - 1.0f).
 */
@property (nonatomic, assign) CGFloat resizeRatio;
/**
 * Number of visible items.
 */
@property (nonatomic, assign) NSUInteger numOfItems;
/**
 * Maximum item size.
 */
@property (nonatomic, assign) CGSize maxItemSize;


@end


NS_ASSUME_NONNULL_END
