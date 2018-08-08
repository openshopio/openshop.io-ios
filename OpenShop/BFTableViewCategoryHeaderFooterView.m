//
//  BFTableViewCategoryHeaderFooterView.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTableViewCategoryHeaderFooterView.h"
#import "BFCategoryTableViewCellExtension.h"

/**
 * Category state indicator image (arrow) rotating animation duration.
 */
static CGFloat const stateIndicatorAnimationDuration  = 0.25;


@interface BFTableViewCategoryHeaderFooterView ()

/**
 * The category state (opened or closed).
 */
@property (nonatomic, assign) BOOL opened;
/**
 * If the category has child categories enable expandable property.
 */
@property (nonatomic, assign) BOOL expandable;


@end


@implementation BFTableViewCategoryHeaderFooterView


#pragma mark - Initialization

- (void)prepareForReuse {
    // remove all animations
    [self.stateIndicator.layer removeAllAnimations];
    // closed by default
    _opened = false;
    // not expandable by default
    _expandable = false;
}


#pragma mark - User Interaction

- (void)setExpandable:(BOOL)expandable {
    self.stateIndicator.hidden = !expandable;
    _expandable = expandable;
}

#pragma mark - State Management

- (void)setOpened:(BOOL)opened animated:(BOOL)animated {
    // save state
    _opened = opened;
    // rotate state indicator (arrow) by 180 degrees
    if (animated) {
        // animation properties
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotationAnimation.fromValue = opened ? @(0.0f) : @(M_PI);
        rotationAnimation.byValue = opened ? @(M_PI) : @(-M_PI);
        rotationAnimation.duration = stateIndicatorAnimationDuration;
        rotationAnimation.fillMode = kCAFillModeForwards;
        rotationAnimation.removedOnCompletion = NO;
        
        [self.stateIndicator.layer addAnimation:rotationAnimation forKey:nil];
    }
    else {
        self.stateIndicator.transform = CGAffineTransformMakeRotation(opened ? M_PI : 0.0f);
    }
}

- (IBAction)toggleState:(id)sender {
    // expand child categories
    if (self.expandable) {
        [self setOpened:!self.opened animated:YES];
        if(self.delegate) {
            [self.delegate categorySectionStateChanged:self.opened onExtension:self.extension];
        }
        else {
            if([self.extension isKindOfClass:[BFCategoryTableViewCellExtension class]]) {
                [(BFCategoryTableViewCellExtension *)self.extension setOpened:true animated:false interaction:false];
            }
        }
    }
    // perform segue from the parent category
    else {
        if(self.delegate) {
            [self.delegate categorySectionActionOnExtension:self.extension];
        }
    }
}



@end
