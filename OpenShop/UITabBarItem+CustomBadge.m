//
//  UITabBarItem+CustomBadge.m
//  CityGlance
//
//  Created by Enrico Vecchio on 18/05/14.
//  Copyright (c) 2014 Cityglance SRL. All rights reserved.
//

#import "UITabBarItem+CustomBadge.h"
#import "UIFont+BFFont.h"

#define CUSTOM_BADGE_TAG 99


@implementation UITabBarItem (CustomBadge)


-(void) setMyAppCustomBadgeValue: (NSString *) value
{
    
    UIFont *myAppFont = [UIFont BFN_robotoRegularWithSize:11.0];
    UIColor *myAppFontColor = [UIColor whiteColor];
    UIColor *myAppBackColor = [UIColor lightGrayColor];
    
    [self setCustomBadgeValue:value withFont:myAppFont andFontColor:myAppFontColor andBackgroundColor:myAppBackColor];
}



-(void) setCustomBadgeValue: (NSString *) value withFont: (UIFont *) font andFontColor: (UIColor *) color andBackgroundColor: (UIColor *) backColor
{
    UIView *v = [self valueForKey:@"view"];
    
    [self setBadgeValue:value];
    
    

    for(UIView *sv in v.subviews)
    {
        
        NSString *str = NSStringFromClass([sv class]);
        
        if([str isEqualToString:@"_UIBadgeView"])
        {
            for(UIView *ssv in sv.subviews)
            {
                // REMOVE PREVIOUS IF EXIST
                if(ssv.tag == CUSTOM_BADGE_TAG) { [ssv removeFromSuperview]; }
            }
            
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sv.frame.size.width, sv.frame.size.height)];
            
            
            [l setFont:font];
            [l setText:value];
            [l setBackgroundColor:backColor];
            [l setTextColor:color];
            [l setTextAlignment:NSTextAlignmentCenter];
            
            l.layer.cornerRadius = l.frame.size.height/2;
            l.layer.masksToBounds = YES;
            
            // Fix for border
            sv.layer.borderWidth = 1;
            sv.layer.borderColor = [backColor CGColor];
            sv.layer.cornerRadius = sv.frame.size.height/2;
            sv.layer.masksToBounds = YES;
            
            
            [sv addSubview:l];
            
            l.tag = CUSTOM_BADGE_TAG;
        }
    }
}




@end
