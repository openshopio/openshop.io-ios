//
//  BFAppAppearance.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAppAppearance.h"
#import "UIColor+BFColor.h"
#import "UIFont+BFFont.h"
#import <MRProgress.h>

@implementation BFAppAppearance


#pragma mark - App Appearance Customization (BFCustomAppearance)

+ (void)customizeAppearance:(BOOL)superClasses; {
    // local class appearance
    [self customizeLocalAppearance:superClasses];
    // global appearance
    [self customizeGlobalAppearance];
}

+ (void)customizeLocalAppearance:(BOOL)superClasses {
    // total number of classes
    int numOfClasses = objc_getClassList(NULL, 0);
    if(numOfClasses) {
        // buffer for classes
        Class *allClasses = (Class *)malloc(sizeof(Class) * numOfClasses);
        // fetch all classes
        numOfClasses = objc_getClassList(allClasses, numOfClasses);
        for (int i = 0; i < numOfClasses; i++) {
            Class class = allClasses[i];
            // check if it conforms to the custom appearance protocol
            if (class_conformsToProtocol(class, @protocol(BFCustomAppearance))) {
                // customize class appearance
                [class customizeAppearance];
            }
            // check if superclass does not implement the custom appearance protocol
            else if(superClasses) {
                Class superClass = class_getSuperclass(class);
                while(superClass) {
                    // check if it conforms to the custom appearance protocol
                    if (class_conformsToProtocol(superClass, @protocol(BFCustomAppearance))) {
                        // customize class appearance
                        [class customizeAppearance];
                        break;
                    }
                    superClass = class_getSuperclass(superClass);
                }
            }
        }
        free(allClasses);
    }
}

+ (void)customizeGlobalAppearance {
    // app window appearance
    [[UIWindow appearance]setTintColor:[UIColor BFN_pinkColor]];
    [[UIWindow appearance]setBackgroundColor:[UIColor whiteColor]];
    // overlay view appearance
    [[MRProgressOverlayView appearance] setTintColor:[UIColor BFN_pinkColor]];
    // tab bar appearance
    [self customizeTabBarTintColor:[UIColor blackColor] selectedImageTintColor:[UIColor whiteColor] backgroundColor:[UIColor whiteColor]];
    [self customizeTabBarItemTitleTextColor:[UIColor whiteColor] selectionColor:[UIColor whiteColor] font:[UIFont BFN_robotoMediumWithSize:10] shadowColor:[UIColor clearColor] shadowOffset:CGSizeZero];
    // navigation bar appearance
    [self customizeNavBarTintColor:[UIColor BFN_greyColor] backgroundColor:nil translucent:false];
    // navigation bar title text
    [self customizeNavBarTitleTextColor:[UIColor blackColor] font:[UIFont BFN_robotoMediumWithSize:15]];
    // navigation bar button item
    [self customizeBarButtonItemTitleTextColor:[UIColor BFN_pinkColor] font:[UIFont BFN_robotoMediumWithSize:15] forState:UIControlStateNormal];
    [self customizeBarButtonItemTitleTextColor:[UIColor BFN_pinkColor] font:[UIFont BFN_robotoMediumWithSize:15] forState:UIControlStateHighlighted];
    // navigation bar back indicator
    [self customizeNavBarBackIndicatorImage:[[UIImage imageNamed:@"BackButtonIcon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] hidesBackButton:YES];
    // activity view controller appearance
    [[UIView appearanceWhenContainedIn: [UIActivityViewController class], nil] setTintColor: [UIColor BFN_pinkColor]];
}


#pragma mark - UITabBar Appearance

+ (void)customizeTabBarTintColor:(UIColor *)tintColor
          selectedImageTintColor:(UIColor *)selectedImageTintColor
                 backgroundColor:(UIColor *)backgroundColor {
    [self customizeTabBarTintColor:tintColor selectedImageTintColor:selectedImageTintColor backgroundColor:backgroundColor selectionIndicatorImage:nil backgroundImage:nil shadowImage:nil containedInClasses:nil];
}

+ (void)customizeTabBarTintColor:(UIColor *)tintColor
          selectedImageTintColor:(UIColor *)selectedImageTintColor
                 backgroundColor:(UIColor *)backgroundColor
         selectionIndicatorImage:(UIImage *)selectionIndicatorImage
                 backgroundImage:(UIImage *)backgroundImage
                     shadowImage:(UIImage *)shadowImage {
    [self customizeTabBarTintColor:tintColor selectedImageTintColor:selectedImageTintColor backgroundColor:backgroundColor selectionIndicatorImage:selectionIndicatorImage backgroundImage:backgroundImage shadowImage:shadowImage containedInClasses:nil];
}

+ (void)customizeTabBarTintColor:(UIColor *)tintColor
          selectedImageTintColor:(UIColor *)selectedImageTintColor
                 backgroundColor:(UIColor *)backgroundColor
         selectionIndicatorImage:(UIImage *)selectionIndicatorImage
                 backgroundImage:(UIImage *)backgroundImage
                     shadowImage:(UIImage *)shadowImage
              containedInClasses:(Class <UIAppearanceContainer>)containerClass, ... {
    
    UITabBar *appearance = !containerClass ? [UITabBar appearance] : [UITabBar appearanceWhenContainedIn:containerClass, nil];
    // properties
    [appearance setBarTintColor:tintColor];
    [appearance setTintColor:selectedImageTintColor];
    [appearance setBackgroundColor:backgroundColor];
    [appearance setBackgroundImage:backgroundImage];
    [appearance setShadowImage:shadowImage];
    [appearance setSelectionIndicatorImage:selectionIndicatorImage];
}


#pragma mark - UITabBarItem Appearance

+ (void)customizeTabBarItemTitleTextColor:(UIColor *)foregroundColor
                           selectionColor:(UIColor *)selectionColor
                                     font:(UIFont *)font
                              shadowColor:(UIColor *)shadowColor
                             shadowOffset:(CGSize)shadowOffset {
    [self customizeTabBarItemTitleTextColor:foregroundColor selectionColor:selectionColor font:font shadowColor:shadowColor shadowOffset:shadowOffset containedInClasses:nil];
}

+ (void)customizeTabBarItemTitleTextColor:(UIColor *)foregroundColor
                           selectionColor:(UIColor *)selectionColor
                                     font:(UIFont *)font
                              shadowColor:(UIColor *)shadowColor
                             shadowOffset:(CGSize)shadowOffset
                       containedInClasses:(Class <UIAppearanceContainer>)containerClass, ... {

    UITabBarItem *appearance = !containerClass ? [UITabBarItem appearance] : [UITabBarItem appearanceWhenContainedIn:containerClass, nil];
    
    // properties
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = shadowColor;
    shadow.shadowOffset = shadowOffset;
    
    [appearance setTitleTextAttributes:@{NSFontAttributeName : font,
                                         NSForegroundColorAttributeName : foregroundColor,
                                         NSShadowAttributeName : shadow
                                         } forState:UIControlStateNormal];
    [appearance setTitleTextAttributes:@{NSFontAttributeName : font,
                                         NSForegroundColorAttributeName : selectionColor,
                                         NSShadowAttributeName : shadow
                                         } forState:UIControlStateSelected];
}


#pragma mark - UINavigationBar Appearance

+ (void)customizeNavBarTintColor:(UIColor *)tintColor
                 backgroundColor:(UIColor *)backgroundColor
                     translucent:(BOOL)translucent {
    [self customizeNavBarTintColor:tintColor backgroundImage:nil backgroundColor:backgroundColor translucent:translucent shadowImage:nil containedInClasses:nil];
}

+ (void)customizeNavBarTintColor:(UIColor *)tintColor
                 backgroundImage:(UIImage *)backgroundImage
                 backgroundColor:(UIColor *)backgroundColor
                     translucent:(BOOL)translucent
                     shadowImage:(UIImage *)shadowImage {
    [self customizeNavBarTintColor:tintColor backgroundImage:backgroundImage backgroundColor:backgroundColor translucent:translucent shadowImage:shadowImage containedInClasses:nil];
}

+ (void)customizeNavBarTintColor:(UIColor *)tintColor
                 backgroundImage:(UIImage *)backgroundImage
                 backgroundColor:(UIColor *)backgroundColor
                     translucent:(BOOL)translucent
                     shadowImage:(UIImage *)shadowImage
              containedInClasses:(Class <UIAppearanceContainer>)containerClass, ... {
    
    UINavigationBar *appearance = !containerClass ? [UINavigationBar appearance] : [UINavigationBar appearanceWhenContainedIn:containerClass, nil];
    // properties
    [appearance setBarTintColor:tintColor];
    [appearance setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [appearance setBackgroundColor:backgroundColor];
    [appearance setShadowImage:shadowImage];
    [appearance setTranslucent:translucent];
}

+ (void)customizeNavBarTitleTextColor:(UIColor *)foregroundColor
                                 font:(UIFont *)font {
    [self customizeNavBarTitleTextColor:foregroundColor font:font shadowColor:nil shadowOffset:CGSizeZero containedInClasses:nil];
}

+ (void)customizeNavBarTitleTextColor:(UIColor *)foregroundColor
                                 font:(UIFont *)font
                   containedInClasses:(Class <UIAppearanceContainer>)containerClass, ... {
    [self customizeNavBarTitleTextColor:foregroundColor font:font shadowColor:nil shadowOffset:CGSizeZero containedInClasses:containerClass];
}

+ (void)customizeNavBarTitleTextColor:(UIColor *)foregroundColor
                                 font:(UIFont *)font
                          shadowColor:(UIColor *)shadowColor
                         shadowOffset:(CGSize)shadowOffset {
    [self customizeNavBarTitleTextColor:foregroundColor font:font shadowColor:shadowColor shadowOffset:shadowOffset containedInClasses:nil];
}

+ (void)customizeNavBarTitleTextColor:(UIColor *)foregroundColor
                                 font:(UIFont *)font
                          shadowColor:(UIColor *)shadowColor
                         shadowOffset:(CGSize)shadowOffset
                   containedInClasses:(Class <UIAppearanceContainer>)containerClass, ... {
    
    UINavigationBar *appearance = !containerClass ? [UINavigationBar appearance] : [UINavigationBar appearanceWhenContainedIn:containerClass, nil];
    // properties
    NSMutableDictionary *properties = [[NSMutableDictionary alloc]initWithDictionary:@{NSFontAttributeName : font,
                                                                                      NSForegroundColorAttributeName : foregroundColor
                                                                                       }];
    if(shadowColor && !CGSizeEqualToSize(shadowOffset, CGSizeZero)) {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = shadowColor;
        shadow.shadowOffset = shadowOffset;
        [properties setValue:shadow forKey:NSShadowAttributeName];
    }

    [appearance setTitleTextAttributes:properties];
}

+ (void)customizeNavBarBackIndicatorImage:(UIImage *)backIndicatorImage
                          hidesBackButton:(BOOL)hidesBackButton {
    [self customizeNavBarBackIndicatorImage:backIndicatorImage hidesBackButton:hidesBackButton containedInClasses:nil];
}

+ (void)customizeNavBarBackIndicatorImage:(UIImage *)backIndicatorImage
                          hidesBackButton:(BOOL)hidesBackButton
                       containedInClasses:(Class <UIAppearanceContainer>)containerClass, ... {
    UINavigationBar *appearance = !containerClass ? [UINavigationBar appearance] : [UINavigationBar appearanceWhenContainedIn:containerClass, nil];
    // properties
    [appearance setBackIndicatorImage:backIndicatorImage];
    [appearance setBackIndicatorTransitionMaskImage:backIndicatorImage];
    appearance.topItem.hidesBackButton = hidesBackButton;
}


#pragma mark - UIBarButtonItem Appearance

+ (void)customizeBarButtonItemBackgroundImage:(nullable UIImage *)backgroundImage
                                     forState:(UIControlState)controlState
                                   barMetrics:(UIBarMetrics)barMetrics {
    [self customizeBarButtonItemBackgroundImage:backgroundImage forState:controlState barMetrics:barMetrics containedInClasses:nil];
}

+ (void)customizeBarButtonItemBackgroundImage:(nullable UIImage *)backgroundImage
                                     forState:(UIControlState)controlState
                                   barMetrics:(UIBarMetrics)barMetrics
                           containedInClasses:(Class <UIAppearanceContainer>)containerClass, ... {
    
    UIBarButtonItem *appearance = !containerClass ? [UIBarButtonItem appearance] : [UIBarButtonItem appearanceWhenContainedIn:containerClass, nil];
    // properties
    [appearance setBackgroundImage:backgroundImage forState:controlState barMetrics:barMetrics];
}

+ (void)customizeBarButtonItemTitleTextColor:(UIColor *)foregroundColor
                                        font:(UIFont *)font
                                    forState:(UIControlState)controlState {
    [self customizeBarButtonItemTitleTextColor:foregroundColor font:font shadowColor:nil shadowOffset:CGSizeZero forState:controlState containedInClasses:nil];
}

+ (void)customizeBarButtonItemTitleTextColor:(UIColor *)foregroundColor
                                        font:(UIFont *)font
                                    forState:(UIControlState)controlState
                          containedInClasses:(Class <UIAppearanceContainer>)containerClass, ... {
    [self customizeBarButtonItemTitleTextColor:foregroundColor font:font shadowColor:nil shadowOffset:CGSizeZero forState:controlState containedInClasses:containerClass];
}

+ (void)customizeBarButtonItemTitleTextColor:(UIColor *)foregroundColor
                                        font:(UIFont *)font
                                 shadowColor:(UIColor *)shadowColor
                                shadowOffset:(CGSize)shadowOffset
                                    forState:(UIControlState)controlState {
    [self customizeBarButtonItemTitleTextColor:foregroundColor font:font shadowColor:shadowColor shadowOffset:shadowOffset forState:controlState containedInClasses:nil];
}

+ (void)customizeBarButtonItemTitleTextColor:(UIColor *)foregroundColor
                                        font:(UIFont *)font
                                 shadowColor:(UIColor *)shadowColor
                                shadowOffset:(CGSize)shadowOffset
                                    forState:(UIControlState)controlState
                          containedInClasses:(Class <UIAppearanceContainer>)containerClass, ... {

    UIBarButtonItem *appearance = !containerClass ? [UIBarButtonItem appearance] : [UIBarButtonItem appearanceWhenContainedIn:containerClass, nil];
    // properties
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = shadowColor;
    shadow.shadowOffset = shadowOffset;
    
    [appearance setTitleTextAttributes:@{NSFontAttributeName : font,
                                         NSForegroundColorAttributeName : foregroundColor,
                                         NSShadowAttributeName : shadow
                                         } forState:controlState];
}


#pragma mark - UIBarButtonItem (Back Bar Button Item) Appearance

+ (void)customizeBackBarButtonItemBackgroundImage:(UIImage *)backgroundImage
             backgroundVerticalPositionAdjustment:(CGFloat)backgroundPositionAdjustment
                                         forState:(UIControlState)controlState
                                       barMetrics:(UIBarMetrics)barMetrics {
    [self customizeBackBarButtonItemBackgroundImage:backgroundImage backgroundVerticalPositionAdjustment:backgroundPositionAdjustment forState:controlState barMetrics:barMetrics containedInClasses:nil];
}

+ (void)customizeBackBarButtonItemBackgroundImage:(UIImage *)backgroundImage
             backgroundVerticalPositionAdjustment:(CGFloat)backgroundPositionAdjustment
                                         forState:(UIControlState)controlState
                                       barMetrics:(UIBarMetrics)barMetrics
                               containedInClasses:(Class <UIAppearanceContainer>)containerClass, ... {
    
    UIBarButtonItem *appearance = !containerClass ? [UIBarButtonItem appearance] : [UIBarButtonItem appearanceWhenContainedIn:containerClass, nil];
    // properties
    [appearance setBackButtonBackgroundImage:backgroundImage forState:controlState barMetrics:barMetrics];
}


#pragma mark - UIPageControl Appearance

+ (void)customizePageControlBackgroundColor:(UIColor *)backgroundColor
             currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                    pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    [self customizePageControlBackgroundColor:backgroundColor currentPageIndicatorTintColor:currentPageIndicatorTintColor pageIndicatorTintColor:pageIndicatorTintColor containedInClasses:nil];
}

+ (void)customizePageControlBackgroundColor:(UIColor *)backgroundColor
             currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                    pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                        containedInClasses:(Class <UIAppearanceContainer>)containerClass, ... {
    
    UIPageControl *appearance = !containerClass ? [UIPageControl appearance] : [UIPageControl appearanceWhenContainedIn:containerClass, nil];
    // properties
    [appearance setBackgroundColor:backgroundColor];
    [appearance setCurrentPageIndicatorTintColor:currentPageIndicatorTintColor];
    [appearance setPageIndicatorTintColor:pageIndicatorTintColor];
}



@end
