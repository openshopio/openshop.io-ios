//
//  BFPushNotificationViewController.m
//  OpenShop
//
//  Created by Petr Škorňok on 14.03.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFPushNotificationViewController.h"
#import "BFPushNotificationHandler.h"

@interface BFPushNotificationViewController ()

@end

@implementation BFPushNotificationViewController

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
    [self.dismissButton setTitle:[self dismissText] forState:UIControlStateNormal];
    [self.confirmButton setTitle:[self confirmText] forState:UIControlStateNormal];
}

#pragma mark - Translations & Dynamic Content

- (NSString *)titleLabelText {
    return BFLocalizedString(kTranslationWouldYouLikeToBeInformed, @"Would you like to be informed about the latest products and offers?");
}

- (NSString *)dismissText {
    return BFLocalizedString(kTranslationNoThanks, @"No thanks");
}

- (NSString *)confirmText {
    return BFLocalizedString(kTranslationYesPlease, @"Yes please");
}

#pragma mark - Dismiss action

- (IBAction)dismissButtonTapped:(id)sender {
    [self dismissFormSheetWithCompletionHandler:^{
        ;
    } animated:YES];
}

- (IBAction)confirmButtonTapped:(id)sender {
    [self dismissFormSheetWithCompletionHandler:^{
        [BFPushNotificationHandler askForPermissions];
    } animated:YES];
}

@end
