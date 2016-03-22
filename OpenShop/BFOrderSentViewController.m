//
//  BFOrderSentViewController.m
//  OpenShop
//
//  Created by Petr Škorňok on 11.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFOrderSentViewController.h"
#import <MZFormSheetPresentationController.h>

@interface BFOrderSentViewController ()

@end

@implementation BFOrderSentViewController

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // update label texts
    self.titleLabel.text = [self titleLabelText];
    self.subtitleLabel.text = [self subtitleLabelText];
    [self.dismissButton setTitle:BFLocalizedString(kTranslationDismiss, @"Dismiss") forState:UIControlStateNormal];
}

#pragma mark - Translations & Dynamic Content

- (NSString *)titleLabelText {
    return BFLocalizedString(kTranslationYourOrderHasBeenSent, @"Your order has been placed. Thank you!");
}

- (NSString *)subtitleLabelText {
    return BFLocalizedString(kTranslationWaitForSMS, @"We’ll send you SMS or e-mail, when everything is prepared.");
}

#pragma mark - Dismiss action

- (IBAction)dismissButtonTapped:(id)sender {
    [self dismissFormSheetWithCompletionHandler:^{
        ;
    } animated:YES];
}


@end
