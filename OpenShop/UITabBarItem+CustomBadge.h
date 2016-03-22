//
//  UITabBarItem+CustomBadge.h
//  CityGlance
//
//  Created by Enrico Vecchio on 18/05/14.
//  Copyright (c) 2014 Cityglance SRL. All rights reserved.
//

@import UIKit;

@interface UITabBarItem (CustomBadge)



-(void) setMyAppCustomBadgeValue: (NSString *) value;

-(void) setCustomBadgeValue: (NSString *) value withFont: (UIFont *) font andFontColor: (UIColor *) color andBackgroundColor: (UIColor *) backColor;

@end
