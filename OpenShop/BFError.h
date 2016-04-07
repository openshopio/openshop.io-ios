//
//  BFError.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

/**
 * Error completion block type. Informing of recovery process result and selected
 * recovery option index.
 */
typedef void (^BFErrorCompletionBlock)(BOOL recovered, NSNumber *_Nullable optionIndex);

/**
 * Error codes.
 */
typedef NS_ENUM(NSInteger, BFErrorCode) {
    BFErrorCodeGeneric,
    BFErrorCodeFacebookLogin,
    BFErrorCodeUserLogin,
    BFErrorCodeUserRegistration,
    BFErrorCodePasswordsMatch,
    BFErrorCodeIncompleteInput,
    BFErrorCodeInvalidInputEmail,
    BFErrorCodeNoData,
    BFErrorCodeWishlistNoProduct,
    BFErrorCodeNoProductVariant,
    BFErrorCodeCartNoProduct
};

/**
 * Error domains.
 */
typedef NS_ENUM(NSInteger, BFErrorDomain) {
    BFErrorDomainRoot = 0,
    BFErrorDomainGeneric,
    BFErrorDomainUser,
    BFErrorDomainFacebook,
    BFErrorDomainInputValidation,
    BFErrorDomainDataFetching,
    BFErrorDomainWishlist
};
/**
 * Error domain names.
 */
static NSString *const BFErrorDomainName[] = {
    @"businessfactory.openshop",
    @"businessfactory.openshop.generic",
    @"businessfactory.openshop.user",
    @"businessfactory.openshop.facebook",
    @"businessfactory.openshop.inputvalidation",
    @"businessfactory.openshop.datafetching",
    @"businessfactory.openshop.wishlist",
};

/**
 * Default error domain. Used when none specified.
 */
static BFErrorDomain const BFErrorDomainDefault = BFErrorDomainRoot;
/**
 * Error domain conversion to its name.
 */
#define BFErrorDomainName(BFErrorDomain) BFErrorDomainName[BFErrorDomain]


/**
 * `BFError` extends `NSError` with easier setup, recovery handling via blocks and direct presentation with alert
 * view or alert controller. Error recovery options can be added or removed on the fly and all the options are
 * presented in alert view with corresponding block callbacks.
 */
@interface BFError : NSError

/**
 * Creates an error object with a specified error domain.
 *
 * @param errorDomain The error domain.
 * @return The newly-initialized `BFError`.
 */
+ (instancetype)errorWithDomain:(BFErrorDomain)errorDomain;
/**
 * Creates an error object with a specified error code. Error domain is automatically determined from the error code.
 *
 * @param errorCode The error code.
 * @return The newly-initialized `BFError`.
 */
+ (instancetype)errorWithCode:(BFErrorCode)errorCode;
/**
 * Creates an error object from existing error information.
 *
 * @param error The error information.
 * @return The newly-initialized `BFError`.
 */
+ (instancetype)errorWithError:(NSError*)error;
/**
 * Creates an error object with a specified error description message.
 *
 * @param message The error description message.
 * @return The newly-initialized `BFError`.
 */
+ (instancetype)errorWithMessage:(NSString*)message;


/**
 * Presents an alert view or alert controller if available. Alert is presented by sender and contains error
 * information with supplied recovery options. Completion block is an optional parameter receiving information
 * of recovery process results.
 *
 * @param sender The alert sender.
 * @param completionBlock The error recovery completion block.
 */
- (void)showAlertFromSender:(id)sender withCompletionBlock:(nullable BFErrorCompletionBlock)completionBlock;
/**
 * Presents an alert view or alert controller if available. Alert is presented by sender and contains error
 * information with supplied recovery options.
 *
 * @param sender The alert sender.
 */
- (void)showAlertFromSender:(id)sender;

/**
 * Returns string containing all the failure messages received from the server concatenated by newline.
 * For example if the user input's bad phone number during the order.
 * @param error The error containing the failure messages received from the API network request.
 */
+ (NSString *)APIFailureMessageWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
