//
//  BFTextField.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTextField.h"


@implementation BFTextField


#pragma mark - Text Rectangle

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + _horizontalMargin, bounds.origin.y + _verticalMargin, bounds.size.width - _horizontalMargin*2, bounds.size.height - _verticalMargin*2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}


#pragma mark - IB Properties Setters

- (void)setHorizontalMargin:(NSInteger)horizontalMargin {
    _horizontalMargin = horizontalMargin;
    [self layoutIfNeeded];
}

- (void)setVerticalMargin:(NSInteger)verticalMargin {
    _verticalMargin = verticalMargin;
    [self layoutIfNeeded];
}

@end


