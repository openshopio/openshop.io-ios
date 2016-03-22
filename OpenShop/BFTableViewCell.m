//
//  BFTableViewCell.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTableViewCell.h"

/**
 * Selection layer fade out animation duration.
 */
static CGFloat const selectionLayerFadeOutDuration = 0.3f;


@interface BFTableViewCell ()
/**
 * The selection layer.
 */
@property (nonatomic, strong) CALayer *selectionLayer;

@end


@implementation BFTableViewCell


#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        self.managesSelection = false;
        // selection layer default color
        self.selectionColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


#pragma mark - Action Button Events

- (IBAction)actionButtonClicked:(id)sender {
    // action button callback
    if(self.actionButtonBlock) {
        self.actionButtonBlock();
    }
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {

}


#pragma mark - Overriden Methods

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if(self.managesSelection) {
        [self updateSelectionLayer:highlighted animated:false];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(self.managesSelection) {
        [self updateSelectionLayer:selected animated:true];
    }
}


#pragma mark - Selection Management

- (CALayer *)selectionLayerForView:(UIView *)view {
    CALayer *selectionLayer = [CALayer layer];
    selectionLayer.backgroundColor = [self.selectionColor CGColor];
    selectionLayer.frame = view.frame;
    return selectionLayer;
}

- (void)updateSelectionLayer:(BOOL)visible animated:(BOOL)animated {
    if(visible) {
        // remove selection layer
        [self.selectionLayer removeFromSuperlayer];
        CALayer *selectionLayer = [self selectionLayerForView:self.contentView];
        [self.contentView.layer addSublayer:selectionLayer];
        self.selectionLayer = selectionLayer;
    }
    else {
        if(animated) {
            // remove selection layer with animation
            CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fadeOutAnimation.fromValue = [NSNumber numberWithFloat:1.0];
            fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.0];
            fadeOutAnimation.duration = selectionLayerFadeOutDuration;
            fadeOutAnimation.delegate = self;
            fadeOutAnimation.fillMode = kCAFillModeForwards;
            fadeOutAnimation.removedOnCompletion = NO;
            [self.selectionLayer addAnimation:fadeOutAnimation forKey:@"opacity"];
        }
        else {
            // remove selection layer
            [self.selectionLayer removeAllAnimations];
            [self.selectionLayer removeFromSuperlayer];
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.selectionLayer) {
        // remove selection layer
        [self.selectionLayer removeFromSuperlayer];
    }
}

- (void)setManagesSelection:(BOOL)managesSelection {
    _managesSelection = managesSelection;
    // remove default selection style
    self.selectionStyle = _managesSelection ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
}


@end
