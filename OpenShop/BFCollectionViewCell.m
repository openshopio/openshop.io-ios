//
//  BFCollectionViewCell.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCollectionViewCell.h"


@implementation BFCollectionViewCell


#pragma mark - Initialization & Lifecycle

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageContentView.image = nil;
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {

}


@end
