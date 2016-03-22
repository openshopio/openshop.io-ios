//
//  BFAppAppearance.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFCustomAppearance` protocol specifies method where class conforming to this protocol
 * can set custom local appearance of its elements.
 */
@protocol BFCustomAppearance <NSObject>

/**
 * Elements local appearance customization.
 */
+ (void)customizeAppearance;

@end

/**
 * `BFAppApperance` is designed to make user interface elements styling options
 * accesible through the bunch of prepared methods. These methods respect the
 * possibility to customize element's appearance inside a specific class. Customizable
 * properties follow the `UIAppearance` proxy.
 */
@interface BFAppAppearance : NSObject

/**
 * Application appearance customization. Global customization rules are applied at first and
 * then all classes conforming to the `BFCustomAppearance` can apply their local appearance
 * customization. Optional parameter specified whether the `BFCustomAppearance` should be
 * inherited from superclasses.
 */
+ (void)customizeAppearance:(BOOL)superClasses;


#pragma mark - UITabBar Appearance

/**
 * Customizes `UITabBar` tint color, selected image tint color and background color.
 *
 * @param tintColor The tint color.
 * @param selectedImageTintColor The selected image tint color.
 * @param backgroundColor The background color.
 */
+ (void)customizeTabBarTintColor:(UIColor *)tintColor
          selectedImageTintColor:(UIColor *)selectedImageTintColor
                 backgroundColor:(UIColor *)backgroundColor;

/**
 * Customizes `UITabBar` tint color, selected image tint color, background color, selection indicator
 * image, background image and shadow image.
 *
 * @param tintColor The tint color.
 * @param selectedImageTintColor The selected image tint color.
 * @param backgroundColor The background color.
 * @param selectionIndicatorImage The selection indicator image.
 * @param backgroundImage The background image.
 * @param shadowImage The shadow image.
 */
+ (void)customizeTabBarTintColor:(UIColor *)tintColor
          selectedImageTintColor:(UIColor *)selectedImageTintColor
                 backgroundColor:(UIColor *)backgroundColor
         selectionIndicatorImage:(nullable UIImage *)selectionIndicatorImage
                 backgroundImage:(nullable UIImage *)backgroundImage
                     shadowImage:(nullable UIImage *)shadowImage;
/**
 * Customizes `UITabBar` tint color, selected image tint color, background color, selection indicator
 * image, background image and shadow image inside specified container classes.
 *
 * @param tintColor The tint color.
 * @param selectedImageTintColor The selected image tint color.
 * @param backgroundColor The background color.
 * @param selectionIndicatorImage The selection indicator image.
 * @param backgroundImage The background image.
 * @param shadowImage The shadow image.
 * @param containerClass The container classes.
 */
+ (void)customizeTabBarTintColor:(UIColor *)tintColor
          selectedImageTintColor:(UIColor *)selectedImageTintColor
                 backgroundColor:(UIColor *)backgroundColor
         selectionIndicatorImage:(nullable UIImage *)selectionIndicatorImage
                 backgroundImage:(nullable UIImage *)backgroundImage
                     shadowImage:(nullable UIImage *)shadowImage
              containedInClasses:(nullable Class <UIAppearanceContainer>)containerClass, ...;


#pragma mark - UITabBarItem Appearance

/**
 * Customizes `UITabBarItem` foreground color, selection color, text font, shadow color and shadow offset.
 *
 * @param foregroundColor The foreground color.
 * @param selectionColor The selection color.
 * @param font The text font.
 * @param shadowColor The text shadow color.
 * @param shadowOffset The text shadow offset.
 */
+ (void)customizeTabBarItemTitleTextColor:(UIColor *)foregroundColor
                           selectionColor:(UIColor *)selectionColor
                                     font:(UIFont *)font
                              shadowColor:(UIColor *)shadowColor
                             shadowOffset:(CGSize)shadowOffset;
/**
 * Customizes `UITabBarItem` foreground color, selection color, font, shadow color and shadow offset
 * inside specified container classes.
 *
 * @param foregroundColor The foreground color.
 * @param selectionColor The selection color.
 * @param font The text font.
 * @param shadowColor The text shadow color.
 * @param shadowOffset The text shadow offset.
 * @param containerClass The container classes.
 */
+ (void)customizeTabBarItemTitleTextColor:(UIColor *)foregroundColor
                           selectionColor:(UIColor *)selectionColor
                                     font:(UIFont *)font
                              shadowColor:(UIColor *)shadowColor
                             shadowOffset:(CGSize)shadowOffset
                       containedInClasses:(nullable Class <UIAppearanceContainer>)containerClass, ...;


#pragma mark - UINavigationBar Appearance

/**
 * Customizes `UINavigationBar` tint color and background color.
 *
 * @param tintColor The tint color.
 * @param backgroundColor The background color.
 * @param translucent The bar translucency.
 */
+ (void)customizeNavBarTintColor:(nullable UIColor *)tintColor
                 backgroundColor:(nullable UIColor *)backgroundColor
                     translucent:(BOOL)translucent;
/**
 * Customizes `UINavigationBar` tint color, background image, background color and shadow image.
 *
 * @param tintColor The tint color.
 * @param backgroundImage The background image.
 * @param backgroundColor The background color.
 * @param translucent The bar translucency.
 * @param shadowImage The shadow image.
 */
+ (void)customizeNavBarTintColor:(nullable UIColor *)tintColor
                 backgroundImage:(nullable UIImage *)backgroundImage
                 backgroundColor:(nullable UIColor *)backgroundColor
                     translucent:(BOOL)translucent
                     shadowImage:(nullable UIImage *)shadowImage;
/**
 * Customizes `UINavigationBar` tint color, background image, background color and shadow image
 * inside specified container classes.
 *
 * @param tintColor The tint color.
 * @param backgroundImage The background image.
 * @param backgroundColor The background color.
 * @param translucent The bar translucency.
 * @param shadowImage The shadow image.
 * @param containerClass The container classes.
 */
+ (void)customizeNavBarTintColor:(nullable UIColor *)tintColor
                 backgroundImage:(nullable UIImage *)backgroundImage
                 backgroundColor:(nullable UIColor *)backgroundColor
                     translucent:(BOOL)translucent
                     shadowImage:(nullable UIImage *)shadowImage
              containedInClasses:(nullable Class <UIAppearanceContainer>)containerClass, ...;

/**
 * Customizes `UINavigationBar` title text foreground color and font.
 *
 * @param foregroundColor The foreground color.
 * @param font The text font.
 */
+ (void)customizeNavBarTitleTextColor:(UIColor *)foregroundColor
                                 font:(UIFont *)font;
/**
 * Customizes `UINavigationBar` title text foreground color, font, shadow color and shadow offset.
 *
 * @param foregroundColor The foreground color.
 * @param font The text font.
 * @param shadowColor The text shadow color.
 * @param shadowOffset The text shadow offset.
 */
+ (void)customizeNavBarTitleTextColor:(UIColor *)foregroundColor
                                 font:(UIFont *)font
                          shadowColor:(nullable UIColor *)shadowColor
                         shadowOffset:(CGSize)shadowOffset;
/**
 * Customizes `UINavigationBar` title text foreground color, font, shadow color and shadow offset
 * inside specified container classes.
 *
 * @param foregroundColor The foreground color.
 * @param font The text font.
 * @param shadowColor The text shadow color.
 * @param shadowOffset The text shadow offset.
 * @param containerClass The container classes.
 */
+ (void)customizeNavBarTitleTextColor:(UIColor *)foregroundColor
                                 font:(UIFont *)font
                          shadowColor:(nullable UIColor *)shadowColor
                         shadowOffset:(CGSize)shadowOffset
                   containedInClasses:(nullable Class <UIAppearanceContainer>)containerClass, ...;
/**
 * Customizes `UINavigationBar` back indicator image and optionally hides the back bar button item.
 *
 * @param backIndicatorImage The back indicator image.
 * @param hidesBackButton If YES the back bar button item is hidden.
 */
+ (void)customizeNavBarBackIndicatorImage:(nullable UIImage *)backIndicatorImage
                          hidesBackButton:(BOOL)hidesBackButton;
/**
 * Customizes `UINavigationBar` back indicator image and optionally hides the back bar button item inside specified container classes.
 *
 * @param backIndicatorImage The back indicator image.
 * @param hidesBackButton If YES the back bar button item is hidden.
 * @param containerClass The container classes.
 */
+ (void)customizeNavBarBackIndicatorImage:(nullable UIImage *)backIndicatorImage
                          hidesBackButton:(BOOL)hidesBackButton
                       containedInClasses:(nullable Class <UIAppearanceContainer>)containerClass, ...;


#pragma mark - UIBarButtonItem Appearance

/**
 * Customizes `UIBarButtonItem` background image for specified control state and bar metrics.
 *
 * @param backgroundImage The background image.
 * @param controlState The control state.
 * @param barMetrics The bar metrics.
 */
+ (void)customizeBarButtonItemBackgroundImage:(nullable UIImage *)backgroundImage
                                     forState:(UIControlState)controlState
                                   barMetrics:(UIBarMetrics)barMetrics;
/**
 * Customizes `UIBarButtonItem` background image for specified control state and bar metrics
 * inside container classes.
 *
 * @param backgroundImage The background image.
 * @param controlState The control state.
 * @param barMetrics The bar metrics.
 * @param containerClass The container classes.
 */
+ (void)customizeBarButtonItemBackgroundImage:(nullable UIImage *)backgroundImage
                                     forState:(UIControlState)controlState
                                   barMetrics:(UIBarMetrics)barMetrics
                           containedInClasses:(nullable Class <UIAppearanceContainer>)containerClass, ...;


/**
 * Customizes `UIBarButtonItem` title text foreground color and font for specified control state.
 *
 * @param foregroundColor The foreground color.
 * @param font The text font.
 * @param controlState The control state.
 */
+ (void)customizeBarButtonItemTitleTextColor:(UIColor *)foregroundColor
                                        font:(UIFont *)font
                                    forState:(UIControlState)controlState;
/**
 * Customizes `UIBarButtonItem` title text foreground color and font for specified control state inside container classes.
 *
 * @param foregroundColor The foreground color.
 * @param font The text font.
 * @param controlState The control state.
 * @param containerClass The container classes.
 */
+ (void)customizeBarButtonItemTitleTextColor:(UIColor *)foregroundColor
                                        font:(UIFont *)font
                                    forState:(UIControlState)controlState
                          containedInClasses:(nullable Class <UIAppearanceContainer>)containerClass, ...;
/**
 * Customizes `UIBarButtonItem` title text foreground color, font, shadow color, shadow offset for specified
 * control state.
 *
 * @param foregroundColor The foreground color.
 * @param font The text font.
 * @param shadowColor The text shadow color.
 * @param shadowOffset The text shadow offset.
 * @param controlState The control state.
 */
+ (void)customizeBarButtonItemTitleTextColor:(UIColor *)foregroundColor
                                        font:(UIFont *)font
                                 shadowColor:(nullable UIColor *)shadowColor
                                shadowOffset:(CGSize)shadowOffset
                                    forState:(UIControlState)controlState;
/**
 * Customizes `UIBarButtonItem` title text foreground color, font, shadow color, shadow offset for specified
 * control state inside container classes.
 *
 * @param foregroundColor The foreground color.
 * @param font The text font.
 * @param shadowColor The text shadow color.
 * @param shadowOffset The text shadow offset.
 * @param controlState The control state.
 * @param containerClass The container classes.
 */
+ (void)customizeBarButtonItemTitleTextColor:(UIColor *)foregroundColor
                                        font:(UIFont *)font
                                 shadowColor:(nullable UIColor *)shadowColor
                                shadowOffset:(CGSize)shadowOffset
                                    forState:(UIControlState)controlState
                          containedInClasses:(nullable Class <UIAppearanceContainer>)containerClass, ...;


#pragma mark - UIBarButtonItem (Back Bar Button Item) Appearance

/**
 * Customizes `UIBarButtonItem` back bar button item background image, background position adjustment, for specified
 * control state and bar metrics.
 *
 * @param backgroundImage The background image.
 * @param backgroundPositionAdjustment The background position adjustment.
 * @param controlState The control state.
 * @param barMetrics The bar metrics.
 */
+ (void)customizeBackBarButtonItemBackgroundImage:(nullable UIImage *)backgroundImage
             backgroundVerticalPositionAdjustment:(CGFloat)backgroundPositionAdjustment
                                         forState:(UIControlState)controlState
                                       barMetrics:(UIBarMetrics)barMetrics;
/**
 * Customizes `UIBarButtonItem` back bar button item background image, background position adjustment, for specified
 * control state and bar metrics inside container classes.
 *
 * @param backgroundImage The background image.
 * @param backgroundPositionAdjustment The background position adjustment.
 * @param controlState The control state.
 * @param barMetrics The bar metrics.
 * @param containerClass The container classes.
 */
+ (void)customizeBackBarButtonItemBackgroundImage:(nullable UIImage *)backgroundImage
             backgroundVerticalPositionAdjustment:(CGFloat)backgroundPositionAdjustment
                                         forState:(UIControlState)controlState
                                       barMetrics:(UIBarMetrics)barMetrics
                               containedInClasses:(nullable Class <UIAppearanceContainer>)containerClass, ...;


#pragma mark - UIPageControl Appearance

/**
 * Customizes `UIPageControl` background color, current page indicator tint color and page indicator tint color.
 *
 * @param backgroundColor The background color.
 * @param currentPageIndicatorTintColor The current page indicator tint color.
 * @param pageIndicatorTintColor The page indicator tint color.
 */
+ (void)customizePageControlBackgroundColor:(UIColor *)backgroundColor
              currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                     pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor;
/**
 * Customizes `UIPageControl` background color, current page indicator tint color and page indicator tint color
 * inside specified container classes.
 *
 * @param backgroundColor The background color.
 * @param currentPageIndicatorTintColor The current page indicator tint color.
 * @param pageIndicatorTintColor The page indicator tint color.
 * @param containerClass The container classes.
 */
+ (void)customizePageControlBackgroundColor:(UIColor *)backgroundColor
              currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                     pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                         containedInClasses:(nullable Class <UIAppearanceContainer>)containerClass, ...;


@end

NS_ASSUME_NONNULL_END
