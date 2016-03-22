//
//  BFNCheckmarkView.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFNCheckmarkView.h"

/**
 * Default checkmark line width.
 */
static CGFloat const checkmarkLineWidth         = 1.5;
/**
 * Default background circle stroke width.
 */
static CGFloat const circleLineWidth            = 1.0;
/**
 * Default selection state change animation duration.
 */
static CGFloat const checkmarkAnimationDuration = 0.4;



@interface BFNCheckmarkView ()

/**
 * Checkmark line layer.
 */
@property(nonatomic, retain) CAShapeLayer *lineLayer;
/**
 * Background circle layer.
 */
@property(nonatomic, retain) CAShapeLayer *circleLayer;
/**
 * Background empty circle layer when not selected.
 */
@property(nonatomic, retain) CAShapeLayer *unselectedCircleLayer;

@end


@implementation BFNCheckmarkView


#pragma mark - Lifecycle / State Changes

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    // default values
    _lineColor = [UIColor whiteColor];
    _backgroundColor = [UIColor blackColor];
    _circleLineColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
    _lineWidth = checkmarkLineWidth;
    _circleLineWidth = circleLineWidth;
    _animateDuration = checkmarkAnimationDuration;
    _animateSelection = true;
    _showsCircle = false;
    _allowsDeselection = true;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL) selected withAnimation:(BOOL)animated {
    super.selected = selected;

    [CATransaction begin];
    [CATransaction setAnimationDuration:(CFTimeInterval) animated ? _animateDuration : 0.0];
    // checkmark selected
    if(self.selected) {
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        self.lineLayer.strokeStart = 0;
        self.lineLayer.strokeEnd = 1;
        self.circleLayer.opacity = 1.0;
        // hide unselected circle
        if(!self.showsCircle) {
            self.unselectedCircleLayer.opacity = 0.0;
        }
        else {
            self.unselectedCircleLayer.opacity = 1.0;
        }
    }
    // checkmark deselected
    else {
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [CATransaction setCompletionBlock:^{
            if (!self.selected) {
                // reset stroke position
                self.lineLayer.strokeStart = 0;
                self.lineLayer.strokeEnd = 0;
            }
        }];
        self.lineLayer.strokeStart = 1;
        self.lineLayer.strokeEnd = 1;
        self.circleLayer.opacity = 0.0;
        // show unselected circle
        self.unselectedCircleLayer.opacity = 1.0;
    }
    [CATransaction commit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // recreate layers
    [_lineLayer removeFromSuperlayer];
    _lineLayer = nil;
    [_circleLayer removeFromSuperlayer];
    _circleLayer = nil;
    [_unselectedCircleLayer removeFromSuperlayer];
    _unselectedCircleLayer = nil;
    [self setSelected:self.selected withAnimation:false];
}


#pragma mark - Layers

- (CAShapeLayer *)lineLayer
{
    if(_lineLayer == nil) {
        // create layer
        _lineLayer = [self checkmarkLayerWithColor:_lineColor];
        [self.layer addSublayer:_lineLayer];
    }
    return _lineLayer;
}

- (CAShapeLayer *)circleLayer
{
    if(_circleLayer == nil) {
        // create layer
        _circleLayer = [self circleLayerWithColor:_backgroundColor];
        // background circle - below checkmark line
        [self.layer insertSublayer:_circleLayer below:self.lineLayer];
    }
    return _circleLayer;
}

- (CAShapeLayer *)unselectedCircleLayer
{
    if(_unselectedCircleLayer == nil) {
        // create layer
        _unselectedCircleLayer = [self unselectedCircleLayerWithColor:_circleLineColor];
        // unselected background circle - below background circle
        [self.layer insertSublayer:_unselectedCircleLayer below:self.circleLayer];
    }
    return _unselectedCircleLayer;
}

- (CAShapeLayer *)unselectedCircleLayerWithColor:(UIColor *)color {
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    
    layer.strokeColor = color.CGColor;
    layer.fillColor   = [UIColor clearColor].CGColor;
    layer.lineCap     = kCALineCapRound;
    layer.lineJoin    = kCALineJoinRound;
    layer.lineWidth   = _circleLineWidth;
    layer.path        = self.circlePath.CGPath;
    
    return layer;
}

- (CAShapeLayer *)circleLayerWithColor:(UIColor *)color {
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    
    layer.strokeColor = [UIColor clearColor].CGColor;
    layer.fillColor   = color.CGColor;
    layer.lineCap     = kCALineCapRound;
    layer.lineJoin    = kCALineJoinRound;
    layer.lineWidth   = _circleLineWidth;
    layer.path        = self.circlePath.CGPath;
    
    return layer;
}

- (CAShapeLayer *)checkmarkLayerWithColor:(UIColor *)color {
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    
    layer.strokeColor = color.CGColor;
    layer.fillColor   = [UIColor clearColor].CGColor;
    layer.lineCap     = kCALineCapRound;
    layer.lineJoin    = kCALineJoinRound;
    layer.lineWidth   = _lineWidth;
    layer.path        = self.checkmarkPath.CGPath;
    
    return layer;
}

- (UIBezierPath *)checkmarkPath {
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:self.startPoint];
    [path addLineToPoint:self.middlePoint];
    [path addLineToPoint:self.endPoint];
    
    return path;
}

- (UIBezierPath *)circlePath {
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path addArcWithCenter:self.boundsCenter radius:self.bounds.size.width/2-2*_lineWidth startAngle:0 endAngle:2*M_PI clockwise:YES];
    return path;
}


#pragma mark - Layer Helpers

- (CGRect)insetRect {
    return CGRectInset(self.bounds, 6*_lineWidth, 6*_lineWidth);
}

- (CGPoint)boundsCenter {
    return CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (CGFloat)innerRadius {
    return MIN(self.insetRect.size.width, self.insetRect.size.height) / 2;
}

- (CGFloat)outerRadius {
    return sqrt(pow(self.insetRect.size.width, 2) + pow(self.insetRect.size.height, 2)) / 2;
}

- (CGPoint)startPoint {
    CGFloat angle = (CGFloat)(13 * M_PI / 12);
    return CGPointMake(self.boundsCenter.x + 7*self.innerRadius/8 * cos(angle), self.boundsCenter.y - 7*self.innerRadius/8 * sin(angle));
}

- (CGPoint)middlePoint {
    return CGPointMake(self.boundsCenter.x - 0.25 * self.innerRadius, self.boundsCenter.y + 0.8 * self.innerRadius);
}

- (CGPoint)endPoint {
    CGFloat angle = (CGFloat)(43 * M_PI / 24);
    return CGPointMake(self.boundsCenter.x + 7*self.outerRadius/8 * cos(angle), self.boundsCenter.y + 7*self.outerRadius/8 * sin(angle));
}


#pragma mark - Touch Interactions

- (void)endTrackingWithTouch:(UITouch *)touches withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touches withEvent:event];
    
    if(CGRectContainsPoint(self.bounds, [touches locationInView:self])) {
        if(!self.selected || self.allowsDeselection) {
            [self setSelected:!self.selected withAnimation:_animateSelection];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}


@end
