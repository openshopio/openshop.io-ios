//
//  BFNavigationStepsView.h
//  OpenShop
//
//  Created by Petr Škorňok on 18.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, BFNavigationStep) {
    BFNavigationStepFirst = 1,
    BFNavigationStepSecond = 2,
    BFNavigationStepThird = 3
};

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFNavigationStepsView` draws navigation steps which
 *  help the user to orientate on which screen he is located.
 */
IB_DESIGNABLE
@interface BFNavigationStepsView : UIView

/**
 * Navigation step to highlight.
 * Enums are not able to set as IBInspectable at the moment. 
 */
@property (nonatomic, assign) IBInspectable NSInteger navigationStep;

@end

NS_ASSUME_NONNULL_END
