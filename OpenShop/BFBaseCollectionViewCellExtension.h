//
//  BFBaseCollectionViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFCollectionViewCellExtension.h"
#import "BFCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFBaseCollectionViewCellExtension` is the base collection view cell extension. It contains
 * basic properties and initialization methods used by all descendants.
 */
@interface BFBaseCollectionViewCellExtension : NSObject <BFCollectionViewCellExtension>

/**
 * Collection view presenting contents of this extension.
 */
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 * Collection view controller managing collection view presenting contents of this extension.
 */
@property (nonatomic, strong) BFCollectionViewController *collectionViewController;

@end

NS_ASSUME_NONNULL_END


