//
//  BFDimControl.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFDimControl.h"

/**
 * Dimming layer background default alpha value.
 */
static CGFloat const defaultHighlightedOverlayAlpha = 0.4;


@interface BFDimControl () 
/**
 * The dimming layers making highlight state.
 */
@property (nonatomic, strong) NSArray *dimLayers;

@end


@implementation BFDimControl


#pragma mark - Highlighted State Change

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted: highlighted];

    if(highlighted) {
        // remove all layers
        [self removeDimLayers];
        
        NSMutableArray *dimLayers = [[NSMutableArray alloc]init];
        for (UIView *subview in self.subviews) {
            // highlight image
            if([subview isKindOfClass:[UIImageView class]]) {
                CALayer *dimLayer = [self dimLayerForView:subview];
                [self.layer addSublayer:dimLayer];
                [dimLayers addObject:dimLayer];
            }
            // highlight label
            else if([subview isKindOfClass:[UILabel class]]) {
                UILabel *labelView = (UILabel *)subview;
                [labelView setHighlighted:true];
            }
        }
        // save layers
        self.dimLayers = dimLayers;
    }
    else {
        // remove all layers
        [self removeDimLayers];
        for (UIView *subview in self.subviews) {
            if([subview isKindOfClass:[UILabel class]]) {
                UILabel *labelView = (UILabel *)subview;
                [labelView setHighlighted:false];
            }
        }
    }
}


#pragma mark - Dimming Layers Management

- (CALayer *)dimLayerForView:(UIView *)view {
    CALayer *dimLayer = [CALayer layer];
    dimLayer.backgroundColor = [[UIColor blackColor] CGColor];
    dimLayer.opacity = self.highlightedOverlayAlpha ? [self.highlightedOverlayAlpha floatValue] : defaultHighlightedOverlayAlpha;
    dimLayer.frame = view.frame;
    return dimLayer;
}

- (void)removeDimLayers {
    for (CALayer *dimLayer in self.dimLayers) {
        [dimLayer removeFromSuperlayer];
    }
    self.dimLayers = nil;
}



@end
