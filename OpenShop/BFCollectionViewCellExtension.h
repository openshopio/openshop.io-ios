//
//  BFCollectionViewCellExtension.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFDataExtension.h"

@class BFCollectionViewController;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFCollectionViewCellExtension` is a protocol specifying required collection view datasource and delegate
 * methods to provide collection view section content and its properties.
 */
@protocol BFCollectionViewCellExtension <BFDataExtension>

@required

/**
 * Collection view controller finished loading. This method should be executed before the collection view displays.
 */
- (void)didLoad;
/**
 * Number of items in the collection view section.
 *
 * @return The number of items.
 */
- (NSUInteger)getNumberOfItems;
/**
 * Collection view cell for item at index path.
 *
 * @param indexPath The item index path.
 * @return The collection view cell.
 */
- (UICollectionViewCell *)getCellForItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 * View for supplementary element of specified kind at index path.
 *
 * @param kind The supplementary element kind.
 * @param indexPath The item index path.
 * @return The supplementary element view.
 */
- (UICollectionReusableView *)getViewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 * Extension initialization with parent collection view controller.
 *
 * @param viewController The parent collection view controller.
 * @return The newly-initialized class implementing `BFCollectionViewCellExtension` protocol.
 */
- (instancetype)initWithCollectionViewController:(BFCollectionViewController *)viewController;
/**
 * Extension initialization with collection view where is the extension's content presented.
 *
 * @param collectionView The collection view.
 * @return The newly-initialized class implementing `BFCollectionViewCellExtension` protocol.
 */
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

/**
 * Collection view item size for item at index path in the collection view layout.
 *
 * @param indexPath The item index path.
 * @param collectionViewLayout The collection view layout.
 * @return The collection view item size.
 */
- (CGSize)layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 * Collection view inset for section at index in the collection view layout.
 *
 * @param section The section index.
 * @param collectionViewLayout The collection view layout.
 * @return The collection view inset.
 */
- (UIEdgeInsets)layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
/**
 * Collection view minimum line spacing for section at index in the collection view layout.
 *
 * @param section The section index.
 * @param collectionViewLayout The collection view layout.
 * @return The collection view minimum line spacing.
 */
- (CGFloat)layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
/**
 * Collection view minimum inter item spacing for section at index in the collection view layout.
 *
 * @param section The section index.
 * @param collectionViewLayout The collection view layout.
 * @return The collection view minimum inter item spacing.
 */
- (CGFloat)layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
/**
 * Collection view reference size for header view in section at index in the collection view layout.
 *
 * @param section The section index.
 * @param collectionViewLayout The collection view layout.
 * @return The reference header view size.
 */
- (CGSize)layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
/**
 * Collection view reference size for footer view in section at index in the collection view layout.
 *
 * @param section The section index.
 * @param collectionViewLayout The collection view layout.
 * @return The reference footer view size.
 */
- (CGSize)layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;


/**
 * Collection view item at index path is about to be highlighted.
 *
 * @param indexPath The item index path.
 * @return TRUE if the item should be highlighted else FALSE.
 */
- (BOOL)shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 * Collection view item at index path was highlighted.
 *
 * @param indexPath The item index path.
 */
- (void)didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 * Collection view item at index path was unhighlighted.
 *
 * @param indexPath The item index path.
 */
- (void)didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 * Collection view item at index path is about to be selected.
 *
 * @param indexPath The item index path.
 * @return TRUE if the item should be selected else FALSE.
 */
- (BOOL)shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 * Collection view item at index path is about to be deselected.
 *
 * @param indexPath The item index path.
 * @return TRUE if the item should be deselected else FALSE.
 */
- (BOOL)shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 * Collection view item at index path was selected.
 *
 * @param indexPath The item index path.
 */
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 * Collection view item at index path was deselected.
 *
 * @param indexPath The item index path.
 */
- (void)didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END


