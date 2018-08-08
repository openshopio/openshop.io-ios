//
//  BFTooltipView.m
//  OpenShop
//
//  Created by Petr Škorňok on 08.10.15.
//  Copyright © 2015 Business-Factory. All rights reserved.
//

#import "BFTooltipView.h"
#import "UIColor+BFColor.h"

/**
 * Default border width.
 */
static CGFloat const defaultBorderWidth  = 0.5;
/**
 * Default popup arrow width.
 */
static CGFloat const defaultArrowWidth   = 40.0;
/**
 * Default popup arrow height.
 */
static CGFloat const defaultArrowHeight  = 20.0;
/**
 * Default corner radius.
 */
static CGFloat const defaultCornerRadius = 0.0;
/**
 * Default margin.
 */
static CGFloat const defaultMargin       = 2.0;



@implementation BFTooltipView


#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    self.backgroundColor = [UIColor clearColor];
    self.color = [UIColor BFN_pinkColor];
    self.borderColor = [UIColor BFN_pinkColor];
    self.borderWidth = defaultBorderWidth;
    self.arrowWidth = defaultArrowWidth;
    self.arrowHeight = defaultArrowHeight;
    self.cornerRadius = defaultCornerRadius;
    self.margin = defaultMargin;
}


#pragma mark - Tooltip Drawing

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    // rectangle size
    CGFloat currentWidth = rect.size.width- 2*self.margin;
    CGFloat currentHeight = rect.size.height - 2*self.margin;

    // drawing options
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, self.borderWidth);
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetFillColorWithColor(context, self.color.CGColor);

    // flip it upside down
    CGContextTranslateCTM(context, 0.0f, currentHeight);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    // tooltip popup arrow
    CGContextBeginPath(context);

    CGContextMoveToPoint(context, self.margin + self.cornerRadius + self.borderWidth, self.margin + self.borderWidth + self.arrowHeight);
    CGContextAddLineToPoint(context, self.margin + round(currentWidth / 2.0f - self.arrowWidth / 2.0f), self.margin + self.arrowHeight + self.borderWidth);
    CGContextAddLineToPoint(context, self.margin + round(currentWidth / 2.0f), self.margin + self.borderWidth);
    CGContextAddLineToPoint(context, self.margin + round(currentWidth / 2.0f + self.arrowWidth / 2.0f), self.margin + self.arrowHeight + self.borderWidth);

    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // tooltip popup rectangle
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.margin+self.borderWidth, self.margin+self.borderWidth + self.arrowHeight, currentWidth-2*self.borderWidth, currentHeight-self.arrowHeight-2*self.borderWidth) cornerRadius:self.cornerRadius];
    [bezierPath stroke];
    [bezierPath fill];
}


@end
