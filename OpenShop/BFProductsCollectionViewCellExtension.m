//
//  BFProductsCollectionViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductsCollectionViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewController.h"
#import "UIImage+BFImageResize.h"
#import <UIImageView+AFNetworking.h>
#import "BFCollectionViewCell.h"
#import "BFAppPreferences.h"
#import "BFCollectionViewLayout.h"
#import "BFProductDetailViewController.h"

/**
 * Product collection view cell reuse identifier.
 */
static NSString *const productItemReuseIdentifier                = @"BFProductCollectionViewCellIdentifier";
/**
 * Products loading footer view reuse identifier.
 */
static NSString *const productsLoadingFooterViewReuseIdentifier  = @"BFProductsLoadingFooterViewIdentifier";
/**
 * Products loading footer view nib file name.
 */
static NSString *const productsLoadingFooterViewNibName          = @"BFLoadingCollectionReusableView";
/**
 * Products loading footer view height.
 */
static CGFloat const productsLoadingFooterViewHeight             = 50.0f;
/**
 * Presenting segue product data model parameter.
 */
static NSString *const segueParameterProduct                     = @"product";


@interface BFProductsCollectionViewCellExtension ()

/**
 * Products calculated height cache.
 */
@property (nonatomic, strong) NSMutableDictionary *productsSizeCache;

@end


@implementation BFProductsCollectionViewCellExtension


#pragma mark - Initialization

- (instancetype)initWithCollectionViewController:(BFCollectionViewController *)viewController {
    self = [super initWithCollectionViewController:viewController];
    if (self) {
        self.products = @[];
        self.showsFooter = false;
        self.productsSizeCache = [NSMutableDictionary new];
    }
    return self;
}

- (void)didLoad {
    // register footer view
    [self.collectionView registerNib:[UINib nibWithNibName:productsLoadingFooterViewNibName bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:productsLoadingFooterViewReuseIdentifier];
}

- (void)setShowsFooter:(BOOL)showsFooter {
    _showsFooter = self.products.count && showsFooter;
}


#pragma mark - UICollectionViewDataSource

- (NSUInteger)getNumberOfItems {
    return [self.products count];
}

- (UICollectionViewCell *)getCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BFCollectionViewCell *cell = (BFCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:productItemReuseIdentifier forIndexPath:indexPath];
    
    if(!cell) {
        cell = [[BFCollectionViewCell alloc]init];
    }
    // product item
    BFProduct *product = [self.products objectAtIndex:indexPath.row];
    
    cell.headerlabel.text = product.name;
    cell.subheaderLabel.attributedText = [product priceAndDiscountFormattedWithPercentage:YES];
    
    [cell setIsAccessibilityElement:YES];
    [cell setAccessibilityLabel:@"ProductCollectionViewCell"];
    [cell setAccessibilityIdentifier:[NSString stringWithFormat:@"ProductCollectionViewCell%ld-%ld", (long)indexPath.section, (long)indexPath.row]];
    
    // set image with resolution based on view type
    BFViewType viewType = (BFViewType)[[[BFAppPreferences sharedPreferences]preferredViewType]integerValue];
    
    NSURL *productImage;
    if(viewType == BFViewTypeSingleItem && product.imageURLHighRes) {
        productImage = [NSURL URLWithString:(NSString *)product.imageURLHighRes];
    }
    else if(viewType == BFViewTypeCollection && product.imageURL) {
        productImage = [NSURL URLWithString:(NSString *)product.imageURL];
    }
    if(productImage) {
        [cell.imageContentView setImageWithURL:productImage placeholderImage:cell.imageContentView.placeholderImage];
    }

    return cell;
}

- (UICollectionReusableView *)getViewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:productsLoadingFooterViewReuseIdentifier forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

- (CGSize)layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return self.showsFooter ? CGSizeMake(self.collectionView.frame.size.width, productsLoadingFooterViewHeight) : CGSizeZero;
}


#pragma mark - UICollectionViewDelegate

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // product item
    BFProduct *product = [self.products objectAtIndex:indexPath.row];
    [self.collectionViewController performSegueWithViewController:[BFProductDetailViewController class] params:@{segueParameterProduct : product}];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if([collectionViewLayout isKindOfClass:[BFCollectionViewLayout class]]) {
        // cached height exists
        if([self.productsSizeCache objectForKey:indexPath]) {
            return [((NSValue *)[self.productsSizeCache objectForKey:indexPath]) CGSizeValue];
        }
        // calculate product item height
        CGSize calculatedSize = [((BFCollectionViewLayout *)collectionViewLayout) itemSizeInCollectionView:self.collectionView];
        [self.productsSizeCache setObject:[NSValue valueWithCGSize:calculatedSize] forKey:indexPath];
        
        return calculatedSize;
    }
    return CGSizeZero;
}

- (void)resetCache {
    self.productsSizeCache = [NSMutableDictionary new];
}



@end
