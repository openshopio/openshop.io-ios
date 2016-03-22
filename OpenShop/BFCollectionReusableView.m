//
//  BFCollectionReusableView.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCollectionReusableView.h"

@interface BFCollectionReusableView ()

/**
 * Content view left margin constraint.
 */
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leftMarginContraint;
/**
 * Content view right margin constraint.
 */
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *rightMarginContraint;

@end


@implementation BFCollectionReusableView


#pragma mark - Action Button Events

- (IBAction)actionButtonClicked:(id)sender {
    // action button callback
    if(self.actionButtonBlock) {
        self.actionButtonBlock();
    }
}


#pragma mark - Content View

- (void)setHorizontalMargin:(CGFloat) margin {
    // update constraints
    self.leftMarginContraint.constant = margin;
    self.rightMarginContraint.constant = margin;
    // update layout
    [self layoutIfNeeded];
}



@end
