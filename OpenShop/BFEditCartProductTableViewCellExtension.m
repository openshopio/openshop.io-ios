//
//  BFEditProducteditCartProductTableViewCellExtension.m
//  OpenShop
//
//  Created by Petr Škorňok on 17.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFEditCartProductTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "BFProductVariant.h"
#import "BFActionSheetPicker.h"
#import "NSArray+BFObjectFiltering.h"
#import "BFProductVariantSize+BFNSelection.h"
#import "BFProductVariantColor+BFNSelection.h"
#import "NSNumber+BFNSelection.h"

/**
 * Maximum number of products of the given variant in the cart.
 */
static NSInteger const quantityLimit = 5;
/**
 * Banner table view cell reuse identifier.
 */
static NSString *const editCartProductCellReuseIdentifier                         = @"BFEditCartProductViewCellIdentifier";
/**
 * Button footer view reuse identifier.
 */
static NSString *const buttonFooterViewReuseIdentifier                            = @"BFTableViewButtonHeaderFooterViewIdentifier";
/**
 * shipping and payment items header view reuse identifier.
 */
static NSString *const editCartProductItemsHeaderViewReuseIdentifier              = @"BFTableViewGroupedHeaderFooterViewIdentifier";
/**
 * shipping and payment items header view nib file name.
 */
static NSString *const editCartProductItemsHeaderViewNibName                      = @"BFTableViewGroupedHeaderFooterView";
/**
 * Button header view nib file name.
 */
static NSString *const buttonFooterViewNibName                                    = @"BFTableViewButtonHeaderFooterView";
/**
 * color and size item table view cell height.
 */
static CGFloat const editCartProductItemCellHeight                                = 42.0;
/**
 * color and size items header view height.
 */
static CGFloat const editCartProductItemsHeaderViewHeight                         = 50.0;
/**
 * color and size items empty footer view height.
 */
static CGFloat const editCartProductItemsEmptyFooterViewHeight                    = 15.0;
/**
 * Color cell tag for later reuse.
 */
static NSInteger const colorCellTag                                               = 77;
/**
 * Size cell tag for later reuse.
 */
static NSInteger const sizeCellTag                                                = 78;

/**
 * Quantity cell tag for later reuse.
 */
static NSInteger const quantityCellTag                                            = 79;

@interface BFEditCartProductTableViewCellExtension ()

/**
 * Edit cart items data source.
 */
@property (nonatomic, strong) NSArray *editCartProductItems;
/**
 * Quantity array created from range 1 to quantityLimit.
 */
@property (nonatomic, strong) NSArray *quantityItems;

@end

@implementation BFEditCartProductTableViewCellExtension

#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super initWithTableViewController:tableViewController];
    if (self) {
        [self setupItems];
    }
    return self;
}

- (void)setupItems {
    // shipping and payment items
    self.editCartProductItems = @[@(BFEditCartProductItemColor), @(BFEditCartProductItemSize), @(BFEditCartProductItemQuantity)];
}

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:editCartProductItemsHeaderViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:editCartProductItemsHeaderViewReuseIdentifier];
}

#pragma mark - Custom getters and setters

- (NSArray *)quantityItems {
    NSMutableArray *array = [NSMutableArray array];
    NSInteger quantityStart = 1;
    for (NSUInteger i = quantityStart; i < quantityStart + quantityLimit; i++) {
        [array addObject:[NSNumber numberWithUnsignedInteger:i]];
    }

    _quantityItems = array;
    return _quantityItems;
}

#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.editCartProductItems count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return editCartProductItemCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:editCartProductCellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:editCartProductCellReuseIdentifier];
    }
    
    switch (index) {
        case BFEditCartProductItemColor: {
            cell.headerlabel.text = BFLocalizedString(kTranslationColor, @"Color");
            cell.subheaderLabel.text = self.selectedProductColor.name;
            cell.tag = colorCellTag;
            
            if (self.productColors.count <= 1) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.subheaderLabel.textColor = [UIColor lightGrayColor];
            }
            break;
        }
        case BFEditCartProductItemSize: {
            cell.headerlabel.text = BFLocalizedString(kTranslationSize, @"Size");
            cell.subheaderLabel.text = self.selectedProductSize.value;
            cell.tag = sizeCellTag;
            
            if (self.productSizes.count <= 1) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.subheaderLabel.textColor = [UIColor lightGrayColor];
            }
            break;
        }
        case BFEditCartProductItemQuantity: {
            cell.headerlabel.text = BFLocalizedString(kTranslationQuantity, @"Quantity");
            cell.subheaderLabel.text = [NSString stringWithFormat:@"%@", self.selectedQuantity];
            cell.tag = quantityCellTag;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:editCartProductItemsHeaderViewReuseIdentifier];
    if(!textHeaderView) {
        textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:editCartProductItemsHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationColorAndSize, @"Color and size") uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return editCartProductItemsHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return editCartProductItemsEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    switch (index) {
        // color
        case BFEditCartProductItemColor: {
            if (self.productColors.count > 1) {
                BFTableViewCell *cell = [self.tableView viewWithTag:colorCellTag];
                [self selectColorClicked:cell];
            }
            break;
        }
        // size
        case BFEditCartProductItemSize: {
            if (self.productSizes.count > 1) {
                BFTableViewCell *cell = [self.tableView viewWithTag:sizeCellTag];
                [self selectSizeClicked:cell];
            }
            break;
        }
        // quantity
        case BFEditCartProductItemQuantity: {
            BFTableViewCell *cell = [self.tableView viewWithTag:quantityCellTag];
            [self selectQuantityClicked:cell];
            break;
        }
        default:
            break;
    }
    
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}

#pragma mark - Product Color Selection

- (void)selectColorClicked:(id)sender {
    // initial selection index
    NSUInteger initialSelection = 0;
    if(self.selectedProductColor && [self.productColors indexOfObject:self.selectedProductColor] != NSNotFound) {
        initialSelection = [self.productColors indexOfObject:self.selectedProductColor];
    }
    
    // selection completion block
    __weak BFTableViewCell *weakSender = (BFTableViewCell *)sender;
    __weak __typeof(self)weakSelf = self;
    BFNActionDoneBlock doneBlock = ^(BFActionSheetPicker *picker, NSInteger selectedIndex, id<BFNSelection> selectedValue) {
        if(selectedValue && [selectedValue isKindOfClass:[BFProductVariantColor class]]) {
            weakSelf.selectedProductColor = (BFProductVariantColor *)selectedValue;
            weakSender.subheaderLabel.text = weakSelf.selectedProductColor.name;
            if (weakSelf.didSelectProductVariantColorBlock) {
                weakSelf.didSelectProductVariantColorBlock(selectedValue);
            }
        }
    };
    
    if (self.productColors) {
        // present selection picker
        [BFActionSheetPicker showPickerWithTitle:BFLocalizedString(kTranslationChooseColor, @"Pick a color")
                                            rows:self.productColors
                                initialSelection:initialSelection
                                       doneBlock:doneBlock
                                     cancelBlock:nil
                                          origin:sender];
    }
}

#pragma mark - Product Size Selection

- (void)selectSizeClicked:(id)sender {
    // initial selection index
    NSUInteger initialSelection = 0;
    if(self.selectedProductSize && [self.productSizes indexOfObject:self.selectedProductSize] != NSNotFound) {
        initialSelection = [self.productSizes indexOfObject:self.selectedProductSize];
    }
    
    // selection completion block
    __weak BFTableViewCell *weakSender = (BFTableViewCell *)sender;
    __weak __typeof(self)weakSelf = self;
    BFNActionDoneBlock doneBlock = ^(BFActionSheetPicker *picker, NSInteger selectedIndex, id<BFNSelection> selectedValue) {
        if(selectedValue && [selectedValue isKindOfClass:[BFProductVariantSize class]]) {
            weakSelf.selectedProductSize = (BFProductVariantSize *)selectedValue;
            weakSender.subheaderLabel.text = weakSelf.selectedProductSize.value;
            if (weakSelf.didSelectProductVariantSizeBlock) {
                weakSelf.didSelectProductVariantSizeBlock(selectedValue);
            }
        }
    };
    
    if (self.productSizes) {
        // present selection picker
        [BFActionSheetPicker showPickerWithTitle:BFLocalizedString(kTranslationChooseSize, @"Pick a size")
                                            rows:self.productSizes
                                initialSelection:initialSelection
                                       doneBlock:doneBlock
                                     cancelBlock:nil
                                          origin:sender];
    }
}

#pragma mark - Product Quantity Selection

- (void)selectQuantityClicked:(id)sender {
    // initial selection index
    NSUInteger initialSelection = 0;
    if(self.selectedQuantity && [self.quantityItems indexOfObject:self.selectedQuantity] != NSNotFound) {
        initialSelection = [self.quantityItems indexOfObject:self.selectedQuantity];
    }

    // selection completion block
    __weak BFTableViewCell *weakSender = (BFTableViewCell *)sender;
    __weak __typeof(self)weakSelf = self;
    BFNActionDoneBlock doneBlock = ^(BFActionSheetPicker *picker, NSInteger selectedIndex, id<BFNSelection> selectedValue) {
        if(selectedValue && [selectedValue isKindOfClass:[NSNumber class]]) {
            weakSelf.selectedQuantity = (NSNumber *)selectedValue;
            weakSender.subheaderLabel.text = [NSString stringWithFormat:@"%@", weakSelf.selectedQuantity];
            if (weakSelf.didSelectQuantityBlock) {
                weakSelf.didSelectQuantityBlock((NSNumber *)selectedValue);
            }
        }
    };
    
    // present selection picker
    [BFActionSheetPicker showPickerWithTitle:BFLocalizedString(kTranslationChooseQuantity, @"Pick a quantity")
                                        rows:self.quantityItems
                            initialSelection:initialSelection
                                   doneBlock:doneBlock
                                 cancelBlock:nil
                                      origin:sender];
}


@end
