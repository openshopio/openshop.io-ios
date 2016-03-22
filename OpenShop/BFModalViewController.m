//
//  BFModalViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFModalViewController.h"


@implementation BFModalViewController


#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    self.animatesDismissal = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // modal view dismiss button
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:BFLocalizedString(kTranslationClose, @"Close") style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = dismissButton;
}


#pragma mark - Modal View Actions

- (void)dismiss {
    [self dismissAnimated:self.animatesDismissal];
}

- (void)dismissAnimated:(BOOL)animated {
    if(self.preCompletion) {
        self.preCompletion();
    }
    [self dismissViewControllerAnimated:self.animatesDismissal completion:self.postCompletion];
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {

}




@end


