//
//  BFProductImageView.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFProductImageView.h"

/**
 * Product placeholder image name.
 */
static NSString *const defaultPlaceholderImage = @"ProductPlaceholder";


@implementation BFProductImageView


#pragma mark - Initialization

- (instancetype)init {
    if ((self = [super init])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    if ((self = [super initWithImage:image])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if ((self = [super initWithImage:image highlightedImage:highlightedImage])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // rendering options
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.layer setMinificationFilter:kCAFilterTrilinear];
    self.clipsToBounds = YES;
    // placeholder image
    self.placeholderImage = [UIImage imageNamed:defaultPlaceholderImage];
}


@end
