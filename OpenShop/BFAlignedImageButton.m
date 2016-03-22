//
//  BFAlignedImageButton.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAlignedImageButton.h"


@implementation BFAlignedImageButton


#pragma mark - Overriden Setters

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self updateInsets];
}

- (void)setImageSpacing:(NSInteger)imageSpacing {
    _imageSpacing = imageSpacing;
    [self updateInsets];
}

- (void)setPushedLeft:(BOOL)pushedLeft {
    _pushedLeft = pushedLeft;
    if(_pushedLeft && _pushedRight) {
        _pushedRight = false;
    }
    [self updateInsets];
}

- (void)setPushedRight:(BOOL)pushedRight {
    _pushedRight = pushedRight;
    if(_pushedRight && _pushedLeft) {
        _pushedLeft = false;
    }
    [self updateInsets];
}

- (void)layoutSubviews {
    [self updateInsets];

    [super layoutSubviews];
}


#pragma mark - Insets Update

- (BOOL)updateInsets {
    BOOL updated = false;
    UIEdgeInsets titleEdgeInsets;
    UIEdgeInsets imageEdgeInsets;
    
    if(self.pushedLeft) {
        // align content to the center
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        // title text insets
        titleEdgeInsets = UIEdgeInsetsMake(0, - self.imageView.image.size.width, 0,0);
        // image insets
        imageEdgeInsets = UIEdgeInsetsMake(0, ceilf(self.titleLabel.frame.size.width - self.frame.size.width + self.imageView.image.size.width/2 + self.imageMargin), 0, 0);
    }
    else if(self.pushedRight) {
        // align content to the center
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        // title text insets
        titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.image.size.width, 0, 0);
        // image insets
        imageEdgeInsets = UIEdgeInsetsMake(0, ceilf(self.frame.size.width - self.imageView.image.size.width - self.imageMargin), 0, 0);
    }
    else {
        // title text insets
        titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.image.size.width, 0, self.imageView.image.size.width);
        // image insets
        imageEdgeInsets = UIEdgeInsetsMake(0, ceilf(self.titleLabel.frame.size.width+self.imageSpacing), 0, ceilf(-self.titleLabel.frame.size.width-self.imageSpacing));
    }
    
    if(!UIEdgeInsetsEqualToEdgeInsets(self.titleEdgeInsets, titleEdgeInsets)) {
        updated = true;
        self.titleEdgeInsets = titleEdgeInsets;
    }
    if(!UIEdgeInsetsEqualToEdgeInsets(self.imageEdgeInsets, imageEdgeInsets)) {
        updated = true;
        self.imageEdgeInsets = imageEdgeInsets;
    }
    
    return updated;
}


#pragma mark - Initialization

- (id)initWithFrame:(CGRect)theFrame {
    self = [super initWithFrame:theFrame];
    if (self) {
        [self updateInsets];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self updateInsets];
    }
    return self;
}



@end


