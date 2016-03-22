//
//  BFBaseCollectionViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFBaseCollectionViewCellExtension.h"


@interface BFBaseCollectionViewCellExtension ()



@end


@implementation BFBaseCollectionViewCellExtension


#pragma mark - Initialization

- (instancetype)initWithCollectionViewController:(BFCollectionViewController *)viewController {
    self = [super init];
    if (self) {
        self.collectionViewController = viewController;
        self.collectionView = (UICollectionView *)viewController.collectionView;
    }
    return self;
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [super init];
    if (self) {
        self.collectionView = collectionView;
    }
    return self;
}

- (void)didLoad {
    // stub implementation (intended to be implemented in the subclass)
}


#pragma mark - UICollectionViewDataSource

- (NSUInteger)getNumberOfItems {
    // stub implementation (intended to be implemented in the subclass)
    return 0;
}

- (UICollectionViewCell *)getCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // stub implementation (intended to be implemented in the subclass)
    return nil;
}

- (UICollectionReusableView *)getViewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    // stub implementation (intended to be implemented in the subclass)
    return nil;
}




@end
