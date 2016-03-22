//
//  BFCollectionViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAppAppearance.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BFCollectionViewCellExtension.h"
#import "BFDataViewController.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * `BFCollectionViewCellExtensionDelegate` is a protocol specifying collection view
 * extension callback methods to perform a view controller transition or any interaction with
 * another collection view extensions.
 */
@protocol BFCollectionViewCellExtensionDelegate <BFDataExtensionDelegate>

@optional

/**
 * Deselects collection view item at index on extension.
 *
 * @param index The collection view item index.
 * @param extension The collection view extension.
 */
- (void)deselectItemAtIndex:(NSInteger)index onExtension:(id)extension;
/**
 * Reloads collection view cell extensions content.
 *
 * @param extensions The collection view cell extensions.
 */
- (void)reloadExtensions:(NSArray<id<BFCollectionViewCellExtension>> *)extensions;

@end

/**
 * `BFCollectionViewController` is a base view controller to add support for collection view.
 * It manages collection view extensions implementing collection view sections content. This
 * controller is also an empty data source and data set delegate which is inherited
 * from the parent `BFDataViewController`.
 */
@interface BFCollectionViewController : BFDataViewController <BFCustomAppearance, BFCollectionViewCellExtensionDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

/**
 * Collection view.
 */
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;


@end

NS_ASSUME_NONNULL_END


