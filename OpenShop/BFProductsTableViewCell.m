//
//  BFProductsTableViewCell.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductsTableViewCell.h"
#import "BFProduct.h"
#import "BFOrderItem.h"
#import "BFCollectionViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "BFProductVariant.h"

/**
 * Product collection view cell reuse identifier.
 */
static NSString *const productContainerCellReuseIdentifier = @"BFProductSmallCollectionViewCellIdentifier";


@interface BFProductsTableViewCell ()


@end


@implementation BFProductsTableViewCell


#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


#pragma mark - Properties Setters

- (void)setData:(NSArray *)data {
    _data = data;
    
    if(self.collectionView) {
        [self.collectionView.collectionViewLayout invalidateLayout];
        [self.collectionView setContentInset:UIEdgeInsetsZero];
        [self.collectionView setContentOffset:CGPointZero animated:NO];
        [self.collectionView reloadData];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data ? [self.data count] : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:productContainerCellReuseIdentifier forIndexPath:indexPath];
    
    id item = [self.data objectAtIndex:indexPath.row];
    
    if ([item isKindOfClass:[BFProduct class]]) {
        BFProduct *product = (BFProduct *)item;
        
        cell.headerlabel.text = product.name;
        cell.subheaderLabel.attributedText = [product priceAndDiscountFormattedWithPercentage:NO];

        if(product.imageURL) {
            NSURL *productImage = [NSURL URLWithString:(NSString *)product.imageURL];
            [cell.imageContentView setImageWithURL:productImage placeholderImage:cell.imageContentView.placeholderImage];
        }
    }
    else if ([item isKindOfClass:[BFOrderItem class]]) {
        BFOrderItem *orderItem = (BFOrderItem *)item;
        BFProductVariant *productVariant = orderItem.productVariant;
        BFProduct *product = productVariant.product;
        
        // product name
        cell.headerlabel.text = [NSString stringWithFormat:@"%@x %@", orderItem.quantity, product.name];
        // product formatted price
        NSString *priceString = [NSString stringWithFormat:@"%@ / %@", productVariant.color.name, productVariant.size.value];
        NSAttributedString *priceAttributedString = [[NSAttributedString alloc] initWithString:priceString ?: @"" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
        cell.subheaderLabel.attributedText = priceAttributedString;
        // product image
        if(product.imageURL) {
            NSURL *productImage = [NSURL URLWithString:(NSString *)product.imageURL];
            [cell.imageContentView setImageWithURL:productImage placeholderImage:cell.imageContentView.placeholderImage];
        }
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.productSelectionBlock) {
        BFProduct *product;
        id item = [self.data objectAtIndex:indexPath.row];
        if ([item isKindOfClass:[BFProduct class]]) {
            product = (BFProduct *)item;
        }
        else if ([item isKindOfClass:[BFOrderItem class]]) {
            product = [[(BFOrderItem *)item productVariant] product];
        }
        
        // notify with product selection
        if(product) {
            self.productSelectionBlock(product);
        }
    }
}





@end
