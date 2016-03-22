//
//  BFBranchTransportView.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFBranchTransportView.h"

@interface BFBranchTransportView ()

/**
 * The transport option view contraints.
 */
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *descriptionLabelTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *descriptionLabelBottomConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewHeightConstraint;

/**
 * Initial transport option view contraints values.
 */
@property (nonatomic, assign) CGFloat descriptionLabelTopValue;
@property (nonatomic, assign) CGFloat descriptionLabelBottomValue;
@property (nonatomic, assign) CGFloat viewHeightValue;
/**
 * The transport view visibility state.
 */
@property (nonatomic, assign) BOOL isDisplayed;

@end


@implementation BFBranchTransportView


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
    self.isDisplayed = true;
}

- (void)didLoad {
    // default contraints values
    self.descriptionLabelTopValue = self.descriptionLabelTopConstraint.constant;
    self.descriptionLabelBottomValue = self.descriptionLabelBottomConstraint.constant;
    self.viewHeightValue = self.viewHeightConstraint.constant;
}

#pragma mark - Visibility

- (void)setVisibility:(BOOL)visible {
    self.isDisplayed = visible;
    // view must shrink before all constraints have been maximized
    if(visible) {
        self.viewHeightConstraint.constant = visible ? self.viewHeightValue : 0;
    }
    
    // contraints update
    self.descriptionLabelTopConstraint.constant = visible ? self.descriptionLabelTopValue : 0;
    self.descriptionLabelBottomConstraint.constant = visible ? self.descriptionLabelBottomValue : 0;
    
    // view must shrink after all constraints have been minimized
    if(!visible) {
        self.viewHeightConstraint.constant = visible ? self.viewHeightValue : 0;
    }
}




@end
