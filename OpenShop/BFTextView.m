//
//  BFTextView.m
//  OpenShop
//
//  Created by Petr Škorňok on 20.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFTextView.h"

@implementation BFTextView

- (void)layoutSubviews {
    [self updateInsets];
    
    [super layoutSubviews];
}

#pragma mark - Insets Update

- (void)updateInsets {
    self.textContainerInset = UIEdgeInsetsMake(self.topInset,
                                               self.leftInset,
                                               self.bottomInset,
                                               self.rightInset);
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)theFrame {
    self = [super initWithFrame:theFrame];
    if (self) {
        [self updateInsets];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self updateInsets];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [self updateInsets];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self updateInsets];
    }
    return self;
}


@end
