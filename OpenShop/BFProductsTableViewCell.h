//
//  BFProductsTableViewCell.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTableViewCell.h"

/**
 * `BFProductsTableViewCell` displays multiple products in a collection view. Each product is represented
 * by a collection view cell.
 */
@interface BFProductsTableViewCell : BFTableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

/**
 * The collection view.
 */
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
/**
 * The products data source.
 */
@property (nonatomic, strong) NSArray *data;
/**
 * Product selection block callback.
 */
@property (nonatomic, copy) void (^productSelectionBlock)(BFProduct *product);



@end
