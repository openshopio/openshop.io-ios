//
//  BFButton.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFButton.h"


@implementation BFButton


#pragma mark - Hit Test

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // no extension or view should not accept touch events
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super hitTest:point withEvent:event];
    }
    
    // the point that is being tested is relative to self so remove origin
    CGRect relativeFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    // test against extended frame
    return CGRectContainsPoint(hitFrame, point) ? self : nil;
}


#pragma mark - Title Label Frame

- (void)layoutSubviews
{
    [super layoutSubviews];
    // update title label frame
    CGRect frame = self.titleLabel.frame;
    frame.size.height = self.bounds.size.height;
    frame.origin.y = self.titleEdgeInsets.top;
    self.titleLabel.frame = frame;
}


#pragma mark - IB Properties Setters

- (void)setHitTestInsetTop:(NSInteger)hitTestInsetTop {
    _hitTestInsetTop = -hitTestInsetTop;
    self.hitTestEdgeInsets = UIEdgeInsetsMake(_hitTestInsetTop, self.hitTestEdgeInsets.left, self.hitTestEdgeInsets.bottom, self.hitTestEdgeInsets.right);
}

- (void)setHitTestInsetRight:(NSInteger)hitTestInsetRight {
    _hitTestInsetRight = -hitTestInsetRight;
    self.hitTestEdgeInsets = UIEdgeInsetsMake(self.hitTestEdgeInsets.top, self.hitTestEdgeInsets.left, self.hitTestEdgeInsets.bottom, _hitTestInsetRight);
}

- (void)setHitTestEdgeInsetLeft:(NSInteger)hitTestInsetLeft {
    _hitTestInsetLeft = -hitTestInsetLeft;
    self.hitTestEdgeInsets = UIEdgeInsetsMake(self.hitTestEdgeInsets.top, _hitTestInsetLeft, self.hitTestEdgeInsets.bottom, self.hitTestEdgeInsets.right);
}

- (void)setHitTestEdgeInsetBottom:(NSInteger)hitTestInsetBottom {
    _hitTestInsetBottom = -hitTestInsetBottom;
    self.hitTestEdgeInsets = UIEdgeInsetsMake(self.hitTestEdgeInsets.top, self.hitTestEdgeInsets.left, _hitTestInsetBottom, self.hitTestEdgeInsets.right);
}

@end


