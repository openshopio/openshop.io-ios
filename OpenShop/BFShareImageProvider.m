//
//  BFShareImageProvider.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFShareImageProvider.h"

@implementation BFShareImageProvider


#pragma mark - Initialization

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithPlaceholderItem:image];
    if (self) {
        self.image = image;
    }
    return self;
}


#pragma mark - Activity Data Item

- (id)item {
    if(![self.activityType isEqualToString:UIActivityTypePostToFacebook]) {
        return self.image;
    }
    return nil;
}

@end
