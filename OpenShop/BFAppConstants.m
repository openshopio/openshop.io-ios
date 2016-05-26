//
//  BFAppConstants.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAppConstants.h"

/**
 * Minimum number of method arguments (target and selector).
 */
NSInteger const kMinNumberOfMethodArguments = 2;

/**
 **********************************************************
 * Notification names.
 **********************************************************
 */

/**
 * Notification name posted when user access token was changed.
 */
NSString *const BFKeyStoreDidChangeAccessTokenChangedNotification = @"BFKeyStoreDidChangeAccessTokenChangedNotification";
/**
 * Notification name posted when user data was saved.
 */
NSString *const BFUserDidSaveNotification                         = @"BFUserDidSaveNotification";
/**
 * Notification name posted when user was logged out.
 */
NSString *const BFUserDidChangeNotification                       = @"BFUserDidChangeNotification";
/**
 * Notification name posted when user authentication is done.
 */
NSString *const BFUserDidAuthenticateNotification                 = @"BFUserDidAuthenticateNotification";
/**
 * Notification name posted when user shopping cart was changed.
 */
NSString *const BFCartDidChangeNotification                       = @"BFCartDidChangeNotification";
/**
 * Notification name posted when user shopping cart needs synchronization.
 * The shopping cart is automatically synchronized with every CRUD operation.
 * If we want to have up to date information when user logs in or changes shop
 * we need to call synchronization manually.
 */
NSString *const BFCartWillSynchronizeNotification                 = @"BFCartWillSynchronizeNotification";
/**
 * Notification name posted when shopping cart badge value was changed.
 */
NSString *const BFCartBadgeValueDidChangeNotification             = @"BFCartBadgeValueDidChangeNotification";
/**
 * Notification name posted when application language was changed.
 */
NSString *const BFLanguageDidChangeNotification                   = @"BFLanguageDidChangeNotification";
/**
 * Notification name posted when device was registered at APNS.
 */
NSString *const BFDeviceDidRegisterNotification                   = @"BFDeviceDidRegisterNotification";
/**
 * Notification name posted when user wishlist was changed.
 */
NSString *const BFWishlistDidChangeNotification                   = @"BFWishlistDidChangeNotification";


/**
 **********************************************************
 * Translation strings keys mapping.
 **********************************************************
 */

/**
 * User's onboarding process.
 */
NSString *const kTranslationChooseCountry                  = @"";
NSString *const kTranslationWhereYouWantToShop             = @"";
NSString *const kTranslationCzechRepublic                  = @"";
NSString *const kTranslationSlovakRepublic                 = @"";
NSString *const kTranslationCzechLanguage                  = @"";
NSString *const kTranslationSlovakLanguage                 = @"";

/**
 * User's onboarding - login.
 */
NSString *const kTranslationEnterEmailAndPassword          = @"";
NSString *const kTranslationDidYouForgetPassword           = @"";
NSString *const kTranslationLogin                          = @"";
NSString *const kTranslationPasswordRetrieval              = @"";
NSString *const kTranslationLoginWithEmail                 = @"";
NSString *const kTranslationPassword                       = @"";
NSString *const kTranslationPasswordRetrievalInProgress    = @"";
NSString *const kTranslationNewPasswordWasSentToYourEmail  = @"";
NSString *const kTranslationErrorIncompleteInput           = @"";
NSString *const kTranslationErrorGeneric                   = @"";
NSString *const kTranslationErrorFacebookLogin             = @"";
NSString *const kTranslationErrorInvalidInputEmail         = @"";
NSString *const kTranslationInput                          = @"";
NSString *const kTranslationLoginError                     = @"";
NSString *const kTranslationLoginErrorCredentials          = @"";
NSString *const kTranslationRegister                       = @"";
NSString *const kTranslationDontHaveAnAccount              = @"";
NSString *const kTranslationMan                            = @"";
NSString *const kTranslationWoman                          = @"";
NSString *const kTranslationRegistrationError              = @"";
NSString *const kTranslationRegistrationErrorCredentials   = @"";
NSString *const kTranslationRegistering                    = @"";
NSString *const kTranslationLoggingIn                      = @"";
NSString *const kTranslationLoginToOpenShop                = @"";
NSString *const kTranslationSkip                           = @"";

/**
 * Push notification permissions.
 */
NSString *const kTranslationWouldYouLikeToBeInformed       = @"";
NSString *const kTranslationYesPlease                      = @"";
NSString *const kTranslationNoThanks                       = @"";

/**
 * Products categories.
 */
NSString *const kTranslationMen                            = @"";
NSString *const kTranslationWomen                          = @"";
NSString *const kTranslationPopular                        = @"";
NSString *const kTranslationSale                           = @"";

/**
 * Products offers.
 */
NSString *const kTranslationJustArrived                    = @"";
NSString *const kTranslationNoOffersHeadline               = @"";
NSString *const kTranslationNoCategoriesHeadline           = @"";

/**
 * APNS.
 */
NSString *const kTranslationHide                           = @"";
NSString *const kTranslationBrowseHere                     = @"";

/**
 * Shopping cart.
 */
NSString *const kTranslationCart                           = @"";
NSString *const kTranslationShoppingCart                   = @"";
NSString *const kTranslationContinue                       = @"";
NSString *const kTranslationEmptyCartHeadline              = @"";
NSString *const kTranslationEmptyCartSubheadline           = @"";
NSString *const kTranslationDiscounts                      = @"";
NSString *const kTranslationProducts                       = @"";
NSString *const kTranslationPieces                         = @"";
NSString *const kTranslationApplyingDiscountCode           = @"";
NSString *const kTranslationApplyDiscountCode              = @"";
NSString *const kTranslationEnterDiscountCode              = @"";
NSString *const kTranslationDiscountCode                   = @"";
NSString *const kTranslationConfirm                        = @"";

/**
 * Edit product in shopping cart
 */
NSString *const kTranslationEditProduct                    = @"";
NSString *const kTranslationQuantity                       = @"";
NSString *const kTranslationChooseQuantity                 = @"";
NSString *const kTranslationColorAndSize                   = @"";
NSString *const kTranslationEdit                           = @"";
NSString *const kTranslationDelete                         = @"";

/**
 * Order form
 */
NSString *const kTranslationShippingAndPayment             = @"";
NSString *const kTranslationContactInformation             = @"";
NSString *const kTranslationName                           = @"";
NSString *const kTranslationNamePlaceholder                = @"";
NSString *const kTranslationEmail                          = @"";
NSString *const kTranslationEmailPlaceholder               = @"";
NSString *const kTranslationPhoneNumber                    = @"";
NSString *const kTranslationPhoneNumberPlaceholder         = @"";
NSString *const kTranslationStreet                         = @"";
NSString *const kTranslationStreetPlaceholder              = @"";
NSString *const kTranslationHouseNo                        = @"";
NSString *const kTranslationHouseNoPlaceholder             = @"";
NSString *const kTranslationCity                           = @"";
NSString *const kTranslationCityPlaceholder                = @"";
NSString *const kTranslationPostalCode                     = @"";
NSString *const kTranslationPostalCodePlaceholder          = @"";
NSString *const kTranslationNote                           = @"";
NSString *const kTranslationPleaseFillInShipping           = @"";
NSString *const kTranslationPleaseFillInPayment            = @"";
NSString *const kTranslationVatIncluded                    = @"";
NSString *const kTranslationByOrderingYouAgreeWithOur      = @"";
NSString *const kTranslationTermsAndConditions             = @"";
NSString *const kTranslationOrder                          = @"";
NSString *const kTranslationPleaseFillInAllFields          = @"";
NSString *const kTranslationSendingOrder                   = @"";
NSString *const kTranslationOrderCommand                   = @"";
NSString *const kTranslationOrderSent                      = @"";

/**
 * Shipping, Payment
 */
NSString *const kTranslationShipping                       = @"";
NSString *const kTranslationPersonalPickup                 = @"";
NSString *const kTranslationPayment                        = @"";
NSString *const kTranslationPaymentMethod                  = @"";

/**
 * Order Summary
 */
NSString *const kTranslationSummary                        = @"";
NSString *const kTranslationYourOrderHasBeenSent           = @"";
NSString *const kTranslationWaitForSMS                     = @"";
NSString *const kTranslationTotal                          = @"";
NSString *const kTranslationAddress                        = @"";
NSString *const kTranslationProductsList                   = @"";
NSString *const kTranslationDismiss                        = @"";

/**
 * Products searching.
 */
NSString *const kTranslationWhoSeeksFinds                  = @"";
NSString *const kTranslationLastSearchedQueries            = @"";
NSString *const kTranslationMostSearchedQueries            = @"";
NSString *const kTranslationNoSearchQueries                = @"";
NSString *const kTranslationSearchSuggestions              = @"";
NSString *const kTranslationCategory                       = @"";
NSString *const kTranslationCancel                         = @"";
NSString *const kTranslationSearch                         = @"";

/**
 * More section.
 */
NSString *const kTranslationOpenShop                       = @"";
NSString *const kTranslationMyWishlist                     = @"";
NSString *const kTranslationBranches                       = @"";
NSString *const kTranslationCountryAndCurrency             = @"";
NSString *const kTranslationUserProfile                    = @"";
NSString *const kTranslationClose                          = @"";
NSString *const kTranslationChangingShop                   = @"";

/*
 * Orders history
 */
NSString *const kTranslationNoOrders                       = @"";
NSString *const kTranslationGoShopping                     = @"";
NSString *const kTranslationOrderDetail                    = @"";

/*
 * Branches
 */
NSString *const kTranslationNavigateToBranch               = @"";

/**
 * Settings.
 */
NSString *const kTranslationNoSettings                     = @"";
NSString *const kTranslationGoBack                         = @"";
NSString *const kTranslationCountry                        = @"";
NSString *const kTranslationLogout                         = @"";
NSString *const kTranslationLoading                        = @"";

/**
 * User details.
 */
NSString *const kTranslationMyAccount                      = @"";
NSString *const kTranslationUserDetailsName                = @"";
NSString *const kTranslationUserDetailsEmail               = @"";
NSString *const kTranslationUserDetailsPhone               = @"";
NSString *const kTranslationUserDetailsStreet              = @"";
NSString *const kTranslationUserDetailsHouseNumber         = @"";
NSString *const kTranslationUserDetailsCity                = @"";
NSString *const kTranslationUserDetailsZip                 = @"";
NSString *const kTranslationUserDetailsOldPassword         = @"";
NSString *const kTranslationUserDetailsNewPassword         = @"";
NSString *const kTranslationUserDetailsConfirmPassword     = @"";
NSString *const kTranslationUserDetailsPasswordChange      = @"";
NSString *const kTranslationUserDetailsConfirm             = @"";
NSString *const kTranslationChangePassword                 = @"";
NSString *const kTranslationPasswordsMatch                 = @"";

/**
 * Empty data set.
 */
NSString *const kTranslationNoItems                        = @"";
NSString *const kTranslationPressForUpdate                 = @"";
NSString *const kTranslationGoToCategories                 = @"";
NSString *const kTranslationNoProducts                     = @"";

/**
 * Products filter
 */
NSString *const kTranslationSortByPopularity               = @"";
NSString *const kTranslationNewestFirst                    = @"";
NSString *const kTranslationPricestFirst                   = @"";
NSString *const kTranslationCheapestFirst                  = @"";
NSString *const kTranslationAll                            = @"";
NSString *const kTranslationFilter                         = @"";
NSString *const kTranslationClearSelection                 = @"";
NSString *const kTranslationFilterSize                     = @"";
NSString *const kTranslationFilterColor                    = @"";
NSString *const kTranslationFilterBrand                    = @"";
NSString *const kTranslationFilterNoFilters                = @"";
NSString *const kTranslationFilterUpdateFilter             = @"";
NSString *const kTranslationPrice                          = @"";
NSString *const kTranslationSort                           = @"";
NSString *const kTranslationSortBy                         = @"";
NSString *const kTranslationCancelFilter                   = @"";
NSString *const kTranslationApplyFilter                    = @"";

/**
 * General info.
 */
NSString *const kTranslationDataFetchingError              = @"";
NSString *const kTranslationDataFetchingErrorReason        = @"";
NSString *const kTranslationError                          = @"";
NSString *const kTranslationErrorDefaultButtonTitle        = @"";

/**
 * Wishlist.
 */
NSString *const kTranslationWishlistNoProductError         = @"";
NSString *const kTranslationWishlistNoProductErrorReason   = @"";
NSString *const kTranslationAddedToWishlist                = @"";
NSString *const kTranslationWishlist                       = @"";
NSString *const kTranslationNoWishlistItems                = @"";
NSString *const kTranslationLoginToRemoveFromWishlist      = @"";

/*
 * Product details.
 */
NSString *const kTranslationShareWithFriends               = @"";
NSString *const kTranslationChooseSize                     = @"";
NSString *const kTranslationChooseColor                    = @"";
NSString *const kTranslationLoginToAddToWishlist           = @"";
NSString *const kTranslationLoginToAddToCart               = @"";
NSString *const kTranslationGoToCart                       = @"";
NSString *const kTranslationSharePlaceholder               = @"";
NSString *const kTranslationShareFacebook                  = @"";
NSString *const kTranslationShareTwitter                   = @"";
NSString *const kTranslationProperties                     = @"";
NSString *const kTranslationCartNoProductError             = @"";
NSString *const kTranslationNoProductVariantErrorReason    = @"";
NSString *const kTranslationRecommended                    = @"";
NSString *const kTranslationAddToCart                      = @"";
NSString *const kTranslationAddingToCart                   = @"";
NSString *const kTranslationAddedToCart                    = @"";
NSString *const kTranslationColor                          = @"";
NSString *const kTranslationSize                           = @"";
NSString *const kTranslationProductIsUnavailable           = @"";
NSString *const kTranslationProductDetail                  = @"";

/*
 * Orders.
 */
NSString *const kTranslationOrderID                        = @"";
NSString *const kTranslationOrderClientName                = @"";
NSString *const kTranslationOrderDateCreated               = @"";
NSString *const kTranslationOrderTotalPrice                = @"";
NSString *const kTranslationOrderShippingName              = @"";
NSString *const kTranslationOrderTransportPrice            = @"";
NSString *const kTranslationOrderItemsList                 = @"";
NSString *const kTranslationOrderElement                   = @"";
NSString *const kTranslationMyOrders                       = @"";


