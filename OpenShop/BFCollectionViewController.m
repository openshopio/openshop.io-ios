//
//  BFCollectionViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCollectionViewController.h"
#import "UIFont+BFFont.h"
#import "UIColor+BFColor.h"
#import "BFCollectionViewCellExtension.h"

@interface BFCollectionViewController ()


@end


@implementation BFCollectionViewController


#pragma mark - Initialization & Cleanup

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    self.collectionView.emptyDataSetSource = nil;
    self.collectionView.emptyDataSetDelegate = nil;
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // empty data source and data set delegates
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    // table view data source and delegate
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    // not loading data
    self.loadingData = false;
}


#pragma mark - BFTableViewCellExtensionDelegate

- (void)deselectItemAtIndex:(NSInteger)index onExtension:(id)extension {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:[self indexOfExtension:extension]];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)reloadExtensions:(NSArray<id<BFCollectionViewCellExtension>> *)extensions {
    [self.collectionView performBatchUpdates:^{
        // reload each extension
        for (id<BFCollectionViewCellExtension> extension in extensions) {
            NSUInteger extensionIndex = [self indexOfExtension:extension];
            if(extensionIndex != NSNotFound) {
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:extensionIndex]];
            }
        }
    } completion:^(BOOL finished) {}];
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {

}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self numOfExtensions];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:section];
    return [extension getNumberOfItems];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:indexPath.section];
    return [extension getCellForItemAtIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:indexPath.section];
    return [extension getViewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:indexPath.section];
    if([extension respondsToSelector:@selector(layout:sizeForItemAtIndexPath:)]) {
        return [extension layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    if([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        return [((UICollectionViewFlowLayout *)collectionViewLayout)itemSize];
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:section];
    if([extension respondsToSelector:@selector(layout:insetForSectionAtIndex:)]) {
        return [extension layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    if([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        return [((UICollectionViewFlowLayout *)collectionViewLayout)sectionInset];
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:section];
    if([extension respondsToSelector:@selector(layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [extension layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
    }
    if([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        return [((UICollectionViewFlowLayout *)collectionViewLayout)minimumLineSpacing];
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:section];
    if([extension respondsToSelector:@selector(layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [extension layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    }
    if([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        return [((UICollectionViewFlowLayout *)collectionViewLayout)minimumInteritemSpacing];
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:section];
    if([extension respondsToSelector:@selector(layout:referenceSizeForHeaderInSection:)]) {
        return [extension layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }
    if([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        return [((UICollectionViewFlowLayout *)collectionViewLayout)headerReferenceSize];
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:section];
    if([extension respondsToSelector:@selector(layout:referenceSizeForFooterInSection:)]) {
        return [extension layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }
    if([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        return [((UICollectionViewFlowLayout *)collectionViewLayout)footerReferenceSize];
    }
    return CGSizeZero;
}


#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:indexPath.section];
    if([extension respondsToSelector:@selector(shouldHighlightItemAtIndex:)]) {
        return [extension shouldHighlightItemAtIndexPath:indexPath];
    }
    return true;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:indexPath.section];
    if([extension respondsToSelector:@selector(didHighlightItemAtIndexPath:)]) {
        [extension didHighlightItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:indexPath.section];
    if([extension respondsToSelector:@selector(didUnhighlightItemAtIndexPath:)]) {
        [extension didUnhighlightItemAtIndexPath:indexPath];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:indexPath.section];
    if([extension respondsToSelector:@selector(shouldSelectItemAtIndexPath:)]) {
        return [extension shouldSelectItemAtIndexPath:indexPath];
    }
    return true;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:indexPath.section];
    if([extension respondsToSelector:@selector(shouldDeselectItemAtIndexPath:)]) {
        return [extension shouldDeselectItemAtIndexPath:indexPath];
    }
    return true;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:indexPath.section];
    if([extension respondsToSelector:@selector(didSelectItemAtIndexPath:)]) {
        [extension didSelectItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    id<BFCollectionViewCellExtension> extension = (id<BFCollectionViewCellExtension>)[self extensionAtIndex:indexPath.section];
    if([extension respondsToSelector:@selector(didDeselectItemAtIndexPath:)]) {
        [extension didDeselectItemAtIndexPath:indexPath];
    }
}


#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return [self numOfExtensions] == 0;
}


#pragma mark - DZNEmptyDataSetDelegate Helpers

- (void)reloadDataFromNetwork {
    
}

- (void)setLoadingData:(BOOL)loadingData {
    super.loadingData = loadingData;
    dispatch_async(dispatch_get_main_queue(), ^{
        // reload empty data set
        [self.collectionView reloadEmptyDataSet];
    });
}



@end
