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
NSString *const kTranslationChooseCountry                  = @"126";
NSString *const kTranslationWhereYouWantToShop             = @"127";
NSString *const kTranslationCzechRepublic                  = @"128";
NSString *const kTranslationSlovakRepublic                 = @"129";
NSString *const kTranslationCzechLanguage                  = @"130";
NSString *const kTranslationSlovakLanguage                 = @"131";

/**
 * User's onboarding - login.
 */
NSString *const kTranslationEnterEmailAndPassword          = @"132";
NSString *const kTranslationDidYouForgetPassword           = @"133";
NSString *const kTranslationLogin                          = @"134";
NSString *const kTranslationPasswordRetrieval              = @"135";
NSString *const kTranslationLoginWithEmail                 = @"136";
NSString *const kTranslationPassword                       = @"137";
NSString *const kTranslationPasswordRetrievalInProgress    = @"138";
NSString *const kTranslationNewPasswordWasSentToYourEmail  = @"139";
NSString *const kTranslationErrorIncompleteInput           = @"140";
NSString *const kTranslationErrorGeneric                   = @"141";
NSString *const kTranslationErrorFacebookLogin             = @"142";
NSString *const kTranslationErrorInvalidInputEmail         = @"143";
NSString *const kTranslationInput                          = @"144";
NSString *const kTranslationLoginError                     = @"145";
NSString *const kTranslationLoginErrorCredentials          = @"146";
NSString *const kTranslationRegister                       = @"147";
NSString *const kTranslationDontHaveAnAccount              = @"";
NSString *const kTranslationMan                            = @"149";
NSString *const kTranslationWoman                          = @"150";
NSString *const kTranslationRegistrationError              = @"151";
NSString *const kTranslationRegistrationErrorCredentials   = @"152";
NSString *const kTranslationRegistering                    = @"153";
NSString *const kTranslationLoggingIn                      = @"68";

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
NSString *const kTranslationNoOffersHeadline               = @"112";
NSString *const kTranslationNoCategoriesHeadline           = @"113";

/**
 * APNS.
 */
NSString *const kTranslationHide                           = @"97";
NSString *const kTranslationBrowseHere                     = @"98";

/**
 * Shopping cart.
 */
NSString *const kTranslationCart                           = @"13";
NSString *const kTranslationShoppingCart                   = @"";
NSString *const kTranslationContinue                       = @"";
NSString *const kTranslationEmptyCartHeadline              = @"115";
NSString *const kTranslationEmptyCartSubheadline           = @"";
NSString *const kTranslationDiscounts                      = @"105";
NSString *const kTranslationProducts                       = @"";
NSString *const kTranslationPieces                         = @"";
NSString *const kTranslationApplyingDiscountCode           = @"";
NSString *const kTranslationApplyDiscountCode              = @"";
NSString *const kTranslationEnterDiscountCode              = @"";
NSString *const kTranslationDiscountCode                   = @"";
NSString *const kTranslationConfirm                        = @"106";

/**
 * Edit product in shopping cart
 */
NSString *const kTranslationEditProduct                    = @"";
NSString *const kTranslationQuantity                       = @"";
NSString *const kTranslationChooseQuantity                 = @"";
NSString *const kTranslationColorAndSize                   = @"4";
NSString *const kTranslationEdit                           = @"20";
NSString *const kTranslationDelete                         = @"21";

/**
 * Order form
 */
NSString *const kTranslationShippingAndPayment             = @"50";
NSString *const kTranslationContactInformation             = @"";
NSString *const kTranslationName                           = @"29";
NSString *const kTranslationNamePlaceholder                = @"";
NSString *const kTranslationEmail                          = @"53";
NSString *const kTranslationEmailPlaceholder               = @"";
NSString *const kTranslationPhoneNumber                    = @"55";
NSString *const kTranslationPhoneNumberPlaceholder         = @"";
NSString *const kTranslationStreet                         = @"52";
NSString *const kTranslationStreetPlaceholder              = @"";
NSString *const kTranslationHouseNo                        = @"54";
NSString *const kTranslationHouseNoPlaceholder             = @"";
NSString *const kTranslationCity                           = @"56";
NSString *const kTranslationCityPlaceholder                = @"";
NSString *const kTranslationPostalCode                     = @"57";
NSString *const kTranslationPostalCodePlaceholder          = @"";
NSString *const kTranslationNote                           = @"58";
NSString *const kTranslationPleaseFillInShipping           = @"";
NSString *const kTranslationPleaseFillInPayment            = @"";
NSString *const kTranslationVatIncluded                    = @"";
NSString *const kTranslationByOrderingYouAgreeWithOur      = @"";
NSString *const kTranslationTermsAndConditions             = @"";
NSString *const kTranslationOrder                          = @"22";
NSString *const kTranslationPleaseFillInAllFields          = @"72";
NSString *const kTranslationSendingOrder                   = @"78";
NSString *const kTranslationOrderCommand                   = @"94";
NSString *const kTranslationOrderSent                      = @"95";

/**
 * Shipping, Payment
 */
NSString *const kTranslationShipping                       = @"32";
NSString *const kTranslationPersonalPickup                 = @"";
NSString *const kTranslationPayment                        = @"48";
NSString *const kTranslationPaymentMethod                  = @"";

/**
 * Order Summary
 */
NSString *const kTranslationSummary                        = @"";
NSString *const kTranslationYourOrderHasBeenSent           = @"";
NSString *const kTranslationWaitForSMS                     = @"";
NSString *const kTranslationTotal                          = @"25";
NSString *const kTranslationAddress                        = @"";
NSString *const kTranslationProductsList                   = @"34";
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
NSString *const kTranslationCancel                         = @"62";
NSString *const kTranslationSearch                         = @"76";

/**
 * More section.
 */
NSString *const kTranslationOpenShop                       = @"";
NSString *const kTranslationMyWishlist                     = @"";
NSString *const kTranslationBranches                       = @"";
NSString *const kTranslationCountryAndCurrency             = @"";
NSString *const kTranslationUserProfile                    = @"";
NSString *const kTranslationClose                          = @"";
NSString *const kTranslationChangingShop                   = @"64";

/*
 * Orders history
 */
NSString *const kTranslationNoOrders                       = @"";
NSString *const kTranslationGoShopping                     = @"";
NSString *const kTranslationOrderDetail                    = @"27";

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
NSString *const kTranslationLogout                         = @"19";
NSString *const kTranslationLoading                        = @"35";

/**
 * User details.
 */
NSString *const kTranslationMyAccount                      = @"15";
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
NSString *const kTranslationSortByPopularity               = @"6";
NSString *const kTranslationNewestFirst                    = @"7";
NSString *const kTranslationPricestFirst                   = @"8";
NSString *const kTranslationCheapestFirst                  = @"9";
NSString *const kTranslationAll                            = @"0";
NSString *const kTranslationFilter                         = @"65";
NSString *const kTranslationClearSelection                 = @"117";
NSString *const kTranslationFilterSize                     = @"118";
NSString *const kTranslationFilterColor                    = @"119";
NSString *const kTranslationFilterBrand                    = @"120";
NSString *const kTranslationFilterNoFilters                = @"123";
NSString *const kTranslationFilterUpdateFilter             = @"124";
NSString *const kTranslationPrice                          = @"73";
NSString *const kTranslationSort                           = @"80";
NSString *const kTranslationSortBy                         = @"81";

/**
 * General info.
 */
NSString *const kTranslationDataFetchingError              = @"";
NSString *const kTranslationDataFetchingErrorReason        = @"";
NSString *const kTranslationError                          = @"87";
NSString *const kTranslationErrorDefaultButtonTitle        = @"125";

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
NSString *const kTranslationRecommending                   = @"2";
NSString *const kTranslationAddToCart                      = @"36";
NSString *const kTranslationAddingToCart                   = @"37";
NSString *const kTranslationAddedToCart                    = @"39";
NSString *const kTranslationColor                          = @"40";
NSString *const kTranslationSize                           = @"41";
NSString *const kTranslationProductIsUnavailable           = @"74";
NSString *const kTranslationProductDetail                  = @"99";

/*
 * Orders.
 */
NSString *const kTranslationOrderID                        = @"83";
NSString *const kTranslationOrderClientName                = @"";
NSString *const kTranslationOrderDateCreated               = @"";
NSString *const kTranslationOrderTotalPrice                = @"";
NSString *const kTranslationOrderShippingName              = @"";
NSString *const kTranslationOrderTransportPrice            = @"";
NSString *const kTranslationOrderItemsList                 = @"";
NSString *const kTranslationOrderElement                   = @"";
NSString *const kTranslationMyOrders                       = @"17";


