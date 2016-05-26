//
//  BFCheckoutTooltipViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCheckoutTooltipViewController.h"
#import "BFTabBarController.h"


@interface BFCheckoutTooltipViewController ()

@end


@implementation BFCheckoutTooltipViewController


#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {

    }
    return self;
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // tooltip content
    self.tooltip.titleLabel.text = BFLocalizedString(kTranslationGoToCart, @"Go to cart");
}

#pragma mark - Touch Actions

- (IBAction)backgroundClicked:(id)sender {
    [self dismissFormSheetWithCompletionHandler:nil animated:YES];
}

- (IBAction)tooltipClicked:(id)sender {
    [self dismissFormSheetWithCompletionHandler:^{
        if (self.tooltipTappedHandler) {
            self.tooltipTappedHandler();
        }
    } animated:YES];
}


@end


