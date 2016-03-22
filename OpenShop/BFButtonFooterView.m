//
//  BFButtonFooterView.m
//  OpenShop
//
//  Created by Petr Škorňok on 27.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFButtonFooterView.h"
#import "UIColor+BFColor.h"

@interface BFButtonFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation BFButtonFooterView

- (void)viewDidLoad {
    [self.actionButton setTitle:self.actionButtonTitle forState:UIControlStateNormal];
    
    self.canPerformAction = YES;
}

- (IBAction)actionButtonTapped:(id)sender {
    // action button callback
    if (self.canPerformAction && self.actionButtonBlock) {
        self.actionButtonBlock();
    }
    else if (!self.canPerformAction && self.disabledActionButtonBlock) {
        self.disabledActionButtonBlock();
    }
}

- (void)setCanPerformAction:(BOOL)canPerformAction {
    _canPerformAction = canPerformAction;
    if (canPerformAction) {
        [self.actionButton setBackgroundColor:[UIColor BFN_pinkColor]];
    }
    else {
        [self.actionButton setBackgroundColor:[UIColor lightGrayColor]];
    }
}

@end
