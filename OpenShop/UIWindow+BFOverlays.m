//
//  UIWindow+BFOverlays.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "UIWindow+BFOverlays.h"
#import <MRProgress.h>
#import <CRToast.h>
#import "UIFont+BFFont.h"
#import "UIColor+BFColor.h"


@implementation UIWindow (BFOverlays)


#pragma mark - Overlays

- (void)showIndeterminateSmallProgressOverlayWithTitle:(NSString *)title animated:(BOOL)animated {
    [MRProgressOverlayView showOverlayAddedTo:self
                                        title:title ? title : @""
                                         mode:MRProgressOverlayViewModeIndeterminateSmall
                                     animated:animated];
}

- (void)showIndeterminateProgressOverlayWithTitle:(NSString *)title animated:(BOOL)animated {
    [MRProgressOverlayView showOverlayAddedTo:self
                                        title:title ? title : @""
                                         mode:MRProgressOverlayViewModeIndeterminate
                                     animated:animated];
}

- (void)showSuccessOverlayWithTitle:(NSString *)title animated:(BOOL)animated {
    [MRProgressOverlayView showOverlayAddedTo:self
                                        title:title ? title : @""
                                         mode:MRProgressOverlayViewModeCheckmark
                                     animated:animated];
}

- (void)showFailureOverlayWithTitle:(NSString *)title animated:(BOOL)animated {
    [MRProgressOverlayView showOverlayAddedTo:self
                                        title:title ? title : @""
                                         mode:MRProgressOverlayViewModeCross
                                     animated:animated];
}

- (void)dismissAllOverlaysWithCompletion:(void(^)())completionBlock animated:(BOOL)animated {
    [MRProgressOverlayView dismissAllOverlaysForView:self animated:animated completion:completionBlock];
}

- (void)dismissAllOverlaysWithCompletion:(void(^)())completionBlock animated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    // invocation with overlay dismiss signature
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(dismissAllOverlaysWithCompletion:animated:)]];
    [invocation setSelector:@selector(dismissAllOverlaysWithCompletion:animated:)];
    [invocation setTarget:self];
    // arguments
    [invocation setArgument:&(completionBlock) atIndex:2];
    [invocation setArgument:&(animated) atIndex:3];
    [invocation retainArguments];
    // invoke after delay
    [invocation performSelector:@selector(invoke) withObject:nil afterDelay:delay];
}


#pragma mark - Toasts Presentation

- (void)showToastWarningMessage:(NSString *)message withCompletion:(void(^)())completionBlock {
    [self showToastWarningMessage:message withOptions:nil completion:completionBlock];
}

- (void)showToastWarningMessage:(NSString *)message withOptions:(NSDictionary *)options completion:(void(^)())completionBlock {
    if (![CRToastManager isShowingNotification]) {
        NSDictionary *mergedOptions = [self mergedToastOptionsWithWarningMessage:message customOptions:options];
        [CRToastManager showNotificationWithOptions:mergedOptions completionBlock:completionBlock];
    }
}

- (void)showToastMessage:(NSString *)message withCompletion:(void(^)())completionBlock {
    [self showToastMessage:message withOptions:nil completion:completionBlock];
}

- (void)showToastMessage:(NSString *)message withOptions:(NSDictionary *)options completion:(void(^)())completionBlock {
    if (![CRToastManager isShowingNotification]) {
        NSDictionary *mergedOptions = [self mergedToastOptionsWithMessage:message customOptions:options];
        [CRToastManager showNotificationWithOptions:mergedOptions completionBlock:completionBlock];
    }
}


#pragma mark - Toasts Options

- (NSDictionary *)mergedToastOptionsWithWarningMessage:(NSString *)message customOptions:(NSDictionary *)options {
    NSMutableDictionary *mergedOptions = [[NSMutableDictionary alloc]initWithDictionary:[self defaultToastOptions]];
    // custom options
    if(options) {
        [mergedOptions addEntriesFromDictionary:options];
    }
    // message
    if(message) {
        [mergedOptions setObject:message forKey:kCRToastTextKey];
    }
    // warning icon
    UIImage *warningImage = [UIImage imageNamed:@"WarningIcon"];
    [mergedOptions setObject:warningImage forKey:kCRToastImageKey];
    return mergedOptions;
}

- (NSDictionary *)mergedToastOptionsWithMessage:(NSString *)message customOptions:(NSDictionary *)options {
    NSMutableDictionary *mergedOptions = [[NSMutableDictionary alloc]initWithDictionary:[self defaultToastOptions]];
    // custom options
    if(options) {
        [mergedOptions addEntriesFromDictionary:options];
    }
    // message
    if(message) {
        [mergedOptions setObject:message forKey:kCRToastTextKey];
    }
    return mergedOptions;
}

- (NSDictionary *)defaultToastOptions {
    return @{
             kCRToastAnimationInTimeIntervalKey: @(0.9),
             kCRToastAnimationOutTimeIntervalKey: @(0.9),
             kCRToastTimeIntervalKey: @(2.5),
             kCRToastNotificationPreferredPaddingKey: @(10),
             kCRToastCaptureDefaultWindowKey: @(YES),
             kCRToastFontKey: [UIFont BFN_robotoMediumWithSize:14],
             kCRToastSubtitleFontKey: [UIFont BFN_robotoRegularWithSize:14],
             kCRToastNotificationTypeKey: @(CRToastTypeStatusBar),
             kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
             kCRToastSubtitleTextAlignmentKey : @(NSTextAlignmentCenter),
             kCRToastBackgroundColorKey : [UIColor BFN_pinkColor],
             kCRToastAnimationInTypeKey : @(CRToastAnimationTypeSpring),
             kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeSpring),
             kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
             kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
             kCRToastImageContentModeKey: @(UIViewContentModeCenter),
             kCRToastImageAlignmentKey: @(CRToastAccessoryViewAlignmentCenter),
             kCRToastCaptureDefaultWindowKey: @(NO),
             };
}


@end

