//
//  BFNSeparatorLine.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFNSeparatorLine.h"

@implementation BFNSeparatorLine

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // no autolayout constraints
    if([self.constraints count] == 0) {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        // correct 1 pixel line height
        if(height == 1.0) {
            height /= [UIScreen mainScreen].scale;
        }
        // frame update
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
    }
    else {
        for(NSLayoutConstraint *constraint in self.constraints) {
            // correct 1 pixel line height
            if(constraint.firstAttribute == NSLayoutAttributeHeight && constraint.constant == 1.0) {
                constraint.constant /= [UIScreen mainScreen].scale;
            }
        }
    }
}



#pragma mark - Margins

-(void)setLeftMargin:(CGFloat)leftMargin {
    if(_leftMarginCons) {
        _leftMarginCons.constant = leftMargin;
        [self layoutIfNeeded];
    }
}

-(void)setRightMargin:(CGFloat)rightMargin {
    if(_rightMarginCons) {
        _rightMarginCons.constant = rightMargin;
        [self layoutIfNeeded];
    }
}

-(void)setBottomMargin:(CGFloat)bottomMargin {
    if(_bottomMarginCons) {
        _bottomMarginCons.constant = bottomMargin;
        [self layoutIfNeeded];
    }
}

-(void)setTopMargin:(CGFloat)topMargin {
    if(_topMarginCons) {
        _topMarginCons.constant = topMargin;
        [self layoutIfNeeded];
    }
}



#pragma mark - Highlight Management

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    // disable background flash when view unhighlighted
    if (CGColorGetAlpha(backgroundColor.CGColor) == 0.0 && _unhighlighting) return;

    [super setBackgroundColor:backgroundColor];
}

-(void)setUnhighlighting:(BOOL)unhighlighting {
    _unhighlighting = unhighlighting;
    // disable background changes until the view highlight flashes
    if(unhighlighting) {
        [self performSelector:@selector(setUnhighlighting:) withObject:false afterDelay:0.3];
    }
}



@end
