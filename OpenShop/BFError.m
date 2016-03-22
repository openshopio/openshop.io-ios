//
//  BFError.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFError.h"
#import "UIAlertController+BFError.h"
#import "UIAlertView+BFError.h"
#import <AFNetworking.h>
@import ObjectiveC.runtime;


/**
 * `BFRecoveryAttempter` encapsulates error recovery options and corresponding block reactions.
 */
@interface BFRecoveryAttempter : NSObject

/**
 * The error recovery options.
 */
@property (nonatomic, strong) NSMutableDictionary *recoveryOptions;

@end


@implementation BFRecoveryAttempter


#pragma mark - BFRecoveryAttempter Initialization

- (id)init {
    self = [super init];
    if (self) {
        _recoveryOptions = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


#pragma mark - Recovery Options Management

- (NSArray *)recoveryOptionTitles {
    return [_recoveryOptions allKeys];
}

- (void)addRecoveryOptionWithTitle:(NSString *)localizedTitle block:(BOOL (^)(void))recoveryBlock {
    [_recoveryOptions setObject:recoveryBlock forKey:localizedTitle];
}

- (void)removeRecoveryOptionWithTitle:(NSString *)localizedTitle {
    [_recoveryOptions removeObjectForKey:localizedTitle];
}

- (void)removeAllRecoveryOptions {
    [_recoveryOptions removeAllObjects];
}


#pragma mark - NSRecoveryAttempting Protocol

- (BOOL)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex {
    BOOL (^recoveryBlock)(void) = [_recoveryOptions objectForKey:[_recoveryOptions.allKeys objectAtIndex:recoveryOptionIndex]];
    return recoveryBlock();
}

- (void)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex delegate:(id)delegate didRecoverSelector:(SEL)didRecoverSelector contextInfo:(void *)contextInfo {
    BOOL (^recoveryBlock)(void) = [_recoveryOptions objectForKey:[_recoveryOptions.allKeys objectAtIndex:recoveryOptionIndex]];
    BOOL didRecover = recoveryBlock();
    SEL nonNullSelector = didRecoverSelector;

    // selector check
    if(nonNullSelector && [delegate respondsToSelector:nonNullSelector]) {
        // invoke original recovery selector with recovery results
        NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:[delegate methodSignatureForSelector:didRecoverSelector]];
        myInvocation.target = delegate;
        myInvocation.selector = nonNullSelector;
        [myInvocation setArgument:&didRecover atIndex:kMinNumberOfMethodArguments];
        [myInvocation setArgument:&contextInfo atIndex:kMinNumberOfMethodArguments+1];
        [myInvocation invoke];
    }
}


@end



@interface BFError ()

/**
 * The error recovery attempter.
 */
@property (nonatomic, strong) BFRecoveryAttempter *customRecoveryAttempter;

@end


@implementation BFError


#pragma mark - BFError Initialization

+ (instancetype)errorWithDomain:(BFErrorDomain)errorDomain {
    BFErrorCode errorCode = [self defaultErrorCodeForDomain:errorDomain];
    return [BFError errorWithDomain:BFErrorDomainName(errorDomain) code:errorCode userInfo:[self userInfoForCode:errorCode]];
}

+ (instancetype)errorWithCode:(BFErrorCode)errorCode {
    return [BFError errorWithDomain:BFErrorDomainName([self errorDomainForCode:errorCode]) code:errorCode userInfo:[self userInfoForCode:errorCode]];
}

+ (instancetype)errorWithError:(NSError*)error {
    return [BFError errorWithDomain:error.domain code:error.code userInfo:error.userInfo];
}

+ (instancetype)errorWithMessage:(NSString *)message {
    BFErrorDomain errorDomain = BFErrorDomainDefault;
    BFErrorCode errorCode = [self defaultErrorCodeForDomain:errorDomain];
    
    return [BFError errorWithDomain:BFErrorDomainName(errorDomain) code:errorCode userInfo:[self userInfoForCode:errorCode withMessage:message]];
}

- (BFRecoveryAttempter *)customRecoveryAttempter {
    if(!_customRecoveryAttempter) {
        _customRecoveryAttempter = [[BFRecoveryAttempter alloc]init];
    }
    return _customRecoveryAttempter;
}

+ (NSDictionary *)userInfoForCode:(BFErrorCode)errorCode withMessage:(NSString *)message {
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
    NSString *description = [self errorCodeDescription:errorCode];
    NSString *failureReason = message ? message : [self errorCodeFailureReason:errorCode];
    NSString *recoverySuggestion = [self errorCodeRecoverySuggestion:errorCode];
    
    [userInfo setValue:description forKey:NSLocalizedDescriptionKey];
    [userInfo setValue:failureReason forKey:NSLocalizedFailureReasonErrorKey];
    [userInfo setValue:recoverySuggestion forKey:NSLocalizedRecoverySuggestionErrorKey];
    
    return userInfo;
}

+ (NSDictionary *)userInfoForCode:(BFErrorCode)errorCode {
    return [self userInfoForCode:errorCode withMessage:nil];
}

+ (NSString *)APIFailureMessageWithError:(NSError *)error
{
    NSError* jsonError;
    NSDictionary* message;
    NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (data != nil) {
        message = [NSJSONSerialization JSONObjectWithData:data
                                                  options:(NSJSONReadingOptions)kNilOptions
                                                    error:&jsonError];
    }
    
    NSString *allMessages = @"";
    for (NSString *s in [message objectForKeyedSubscript:@"body"]) {
        allMessages = [NSString stringWithFormat:@"%@\n%@", allMessages, s];
    }
    
    return allMessages;
}

#pragma mark - BFError Codes & Domains Description

+ (BFErrorDomain)errorDomainForCode:(BFErrorCode)code {
    switch (code) {
        case BFErrorCodeGeneric:
            return BFErrorDomainGeneric;
        case BFErrorCodeIncompleteInput:
            return BFErrorDomainInputValidation;
        case BFErrorCodeFacebookLogin:
            return BFErrorDomainFacebook;
        case BFErrorCodePasswordsMatch:
            return BFErrorDomainInputValidation;
        case BFErrorCodeInvalidInputEmail:
            return BFErrorDomainInputValidation;
        case BFErrorCodeUserLogin:
            return BFErrorDomainUser;
        case BFErrorCodeNoData:
            return BFErrorDomainDataFetching;
        case BFErrorCodeUserRegistration:
            return BFErrorDomainUser;
        case BFErrorCodeWishlistNoProduct:
            return BFErrorDomainWishlist;
        default:
            break;
    }
    
    return BFErrorDomainDefault;
}

+ (BFErrorCode)defaultErrorCodeForDomain:(BFErrorDomain)code {
    switch (code) {
        case BFErrorDomainGeneric:
            return BFErrorCodeGeneric;
        case BFErrorDomainInputValidation:
            return BFErrorCodeIncompleteInput;
        case BFErrorDomainFacebook:
            return BFErrorCodeFacebookLogin;
        case BFErrorDomainUser:
            return BFErrorCodeUserLogin;
        case BFErrorDomainDataFetching:
            return BFErrorCodeNoData;
        case BFErrorDomainWishlist:
            return BFErrorCodeWishlistNoProduct;
        default:
            break;
    }
    
    return BFErrorCodeGeneric;
}

+ (NSString *)errorCodeDescription:(BFErrorCode)code  {
    switch (code) {
        case BFErrorCodeGeneric:
            return BFLocalizedString(kTranslationError, @"Error");
        case BFErrorCodeIncompleteInput:
            return BFLocalizedString(kTranslationInput, @"Input");
        case BFErrorCodeFacebookLogin:
            return BFLocalizedString(kTranslationError, @"Error");
        case BFErrorCodePasswordsMatch:
            return BFLocalizedString(kTranslationUserDetailsPasswordChange, @"Change password");
        case BFErrorCodeInvalidInputEmail:
            return BFLocalizedString(kTranslationEmail, @"Email");
        case BFErrorCodeUserLogin:
            return BFLocalizedString(kTranslationLoginError, @"Login error");
        case BFErrorCodeUserRegistration:
            return BFLocalizedString(kTranslationRegistrationError, @"Registration error");
        case BFErrorCodeNoData:
            return BFLocalizedString(kTranslationDataFetchingError, @"Data fetching error");
        case BFErrorCodeWishlistNoProduct:
            return BFLocalizedString(kTranslationWishlistNoProductError, @"Product is unavailable");
        default:
            break;
    }
    return nil;
}

+ (NSString *)errorCodeFailureReason:(BFErrorCode)code  {
    switch (code) {
        case BFErrorCodeGeneric:
            return BFLocalizedString(kTranslationErrorGeneric, @"There was an error while processing your request.");
        case BFErrorCodeIncompleteInput:
            return BFLocalizedString(kTranslationErrorIncompleteInput, @"Incomplete input.");
        case BFErrorCodeFacebookLogin:
            return BFLocalizedString(kTranslationErrorFacebookLogin, @"Cannot connect to Facebook.");
        case BFErrorCodePasswordsMatch:
            return BFLocalizedString(kTranslationPasswordsMatch, @"Passwords don't match.");
        case BFErrorCodeInvalidInputEmail:
            return BFLocalizedString(kTranslationErrorInvalidInputEmail, @"Please enter a valid email address.");
        case BFErrorCodeUserLogin:
            return BFLocalizedString(kTranslationLoginErrorCredentials, @"Incorrect login credentials.");
        case BFErrorCodeUserRegistration:
            return BFLocalizedString(kTranslationRegistrationErrorCredentials, @"Email address already registered.");
        case BFErrorCodeNoData:
            return BFLocalizedString(kTranslationDataFetchingErrorReason, @"There was an error while fetching the data. Please try again later.");
        case BFErrorCodeWishlistNoProduct:
            return BFLocalizedString(kTranslationWishlistNoProductErrorReason, @"Product cannot be added or removed from wishlist. Please try again later.");
        default:
            break;
    }
    return nil;
}

+ (NSString *)errorCodeRecoverySuggestion:(BFErrorCode)code  {
    switch (code) {
        case BFErrorCodeGeneric:
        case BFErrorCodePasswordsMatch:
        case BFErrorCodeIncompleteInput:
        case BFErrorCodeInvalidInputEmail:
        case BFErrorCodeFacebookLogin:
        case BFErrorCodeUserLogin:
        case BFErrorCodeUserRegistration:
        case BFErrorCodeNoData:
        case BFErrorCodeWishlistNoProduct:
            return nil;
        default:
            break;
    }
    return nil;
}


#pragma mark - BFError Recovery Options

- (void)addRecoveryOptionWithTitle:(NSString *)localizedTitle block:(BOOL (^)(void))recoveryBlock {
    [self.customRecoveryAttempter addRecoveryOptionWithTitle:[localizedTitle copy] block:[recoveryBlock copy]];
}

- (void)addCancelRecoveryOption {
    [self.customRecoveryAttempter addRecoveryOptionWithTitle:BFLocalizedString(kTranslationErrorDefaultButtonTitle, @"OK") block:^BOOL() {
        return false;
    }];
}

- (void)removeRecoveryOptionWithTitle:(NSString *)localizedTitle {
    [self.customRecoveryAttempter removeRecoveryOptionWithTitle:localizedTitle];
}

- (void)removeAllRecoveryOptions {
    [self.customRecoveryAttempter removeAllRecoveryOptions];
}


#pragma mark - BFError Presentation

- (NSDictionary *)updatedUserInfo {
    NSMutableDictionary *mutableUserInfo = [self.userInfo mutableCopy];
    NSArray *recoveryOptions = [self.customRecoveryAttempter recoveryOptionTitles];
    // recovery options availaible
    if([recoveryOptions count]) {
        [mutableUserInfo setObject:recoveryOptions forKey:NSLocalizedRecoveryOptionsErrorKey];
        [mutableUserInfo setObject:self.customRecoveryAttempter forKey:NSRecoveryAttempterErrorKey];
    }
    // remove recovery attempter if none specified
    else if(!self.localizedRecoveryOptions) {
        [mutableUserInfo removeObjectForKey:NSLocalizedRecoveryOptionsErrorKey];
        [mutableUserInfo removeObjectForKey:NSRecoveryAttempterErrorKey];
    }
    return mutableUserInfo;
}

- (void)showAlertFromSender:(id)sender withCompletionBlock:(BFErrorCompletionBlock)block {
    // shows alert controller if availaible
    if ([UIAlertController class]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithError:[BFError errorWithDomain:self.domain code:self.code userInfo:[self updatedUserInfo]] preferredStyle:UIAlertControllerStyleAlert completionBlock:block];
        [sender presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithError:[BFError errorWithDomain:self.domain code:self.code userInfo:[self updatedUserInfo]] completionBlock:block];
        [alertView show];
    }
}

- (void)showAlertFromSender:(id)sender {
    [self showAlertFromSender:sender withCompletionBlock:nil];
}


@end
