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

/**
 * Push notification permissions.
 */
NSString *const kTranslationWouldYouLikeToBeInformed       = @"";
NSString *const kTranslationYesPlease                      = @"";
NSString *const kTranslationNoThanks                       = @"";

/**
 * Products categories.
 */
NSString *const kTranslationMen                            = @"154";
NSString *const kTranslationWomen                          = @"155";
NSString *const kTranslationDesign                         = @"156";
NSString *const kTranslationCatalogue                      = @"157";
NSString *const kTranslationPopular                        = @"";
NSString *const kTranslationSale                           = @"159";

/**
 * Products offers.
 */
NSString *const kTranslationJustArrived                    = @"160";

/**
 * APNS.
 */
NSString *const kTranslationHide                           = @"97";
NSString *const kTranslationBrowseHere                     = @"98";

/**
 * Shopping cart.
 */
NSString *const kTranslationShoppingCart                   = @"161";
NSString *const kTranslationContinue                       = @"";
NSString *const kTranslationEmptyCartHeadline              = @"115";
NSString *const kTranslationEmptyCartSubheadline           = @"";
NSString *const kTranslationProductsInCart                 = @"24";
NSString *const kTranslationDiscounts                      = @"105";
NSString *const kTranslationProducts                       = @"";
NSString *const kTranslationPieces                         = @"";
NSString *const kTranslationApplyingDiscountCode           = @"";
NSString *const kTranslationApplyDiscountCode              = @"";
NSString *const kTranslationEnterDiscountCode              = @"";
NSString *const kTranslationDiscountCode                   = @"";

/**
 * Edit product in shopping cart
 */
NSString *const kTranslationEditProduct                    = @"";
NSString *const kTranslationQuantity                       = @"";
NSString *const kTranslationChooseQuantity                 = @"";

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
NSString *const kTranslationYourOrder                      = @"";
NSString *const kTranslationYourOrderHasBeenSent           = @"";
NSString *const kTranslationWaitForSMS                     = @"";
NSString *const kTranslationTotal                          = @"25";
NSString *const kTranslationAddress                        = @"";
NSString *const kTranslationProductsList                   = @"34";
NSString *const kTranslationDismiss                        = @"";

/**
 * Products searching.
 */
NSString *const kTranslationWhoSeeksFinds                  = @"162";
NSString *const kTranslationLastSearchedQueries            = @"163";
NSString *const kTranslationMostSearchedQueries            = @"164";
NSString *const kTranslationNoSearchQueries                = @"165";
NSString *const kTranslationSearchSuggestions              = @"";
NSString *const kTranslationCategory                       = @"";

/**
 * More section.
 */
NSString *const kTranslationOpenShop                       = @"166";
NSString *const kTranslationMyWishlist                     = @"167";
NSString *const kTranslationBranches                       = @"168";
NSString *const kTranslationCountryAndCurrency             = @"169";
NSString *const kTranslationUserProfile                    = @"170";
NSString *const kTranslationClose                          = @"171";

/*
 * Orders history
 */
NSString *const kTranslationNoOrders                       = @"172";
NSString *const kTranslationGoShopping                     = @"173";

/*
 * Branches
 */
NSString *const kTranslationNavigateToBranch               = @"174";

/**
 * Settings.
 */
NSString *const kTranslationNoSettings                     = @"175";
NSString *const kTranslationGoBack                         = @"176";
NSString *const kTranslationCountry                        = @"177";

/**
 * User details.
 */
NSString *const kTranslationUserDetailsName                = @"178";
NSString *const kTranslationUserDetailsEmail               = @"179";
NSString *const kTranslationUserDetailsPhone               = @"180";
NSString *const kTranslationUserDetailsStreet              = @"181";
NSString *const kTranslationUserDetailsHouseNumber         = @"182";
NSString *const kTranslationUserDetailsCity                = @"183";
NSString *const kTranslationUserDetailsZip                 = @"184";
NSString *const kTranslationUserDetailsOldPassword         = @"185";
NSString *const kTranslationUserDetailsNewPassword         = @"186";
NSString *const kTranslationUserDetailsConfirmPassword     = @"187";
NSString *const kTranslationUserDetailsPasswordChange      = @"188";
NSString *const kTranslationUserDetailsConfirm             = @"189";
NSString *const kTranslationChangePassword                 = @"190";
NSString *const kTranslationPasswordsMatch                 = @"191";

/**
 * Empty data set.
 */
NSString *const kTranslationNoItems                        = @"192";
NSString *const kTranslationPressForUpdate                 = @"193";
NSString *const kTranslationGoToCategories                 = @"194";
NSString *const kTranslationNoProducts                     = @"195";

/**
 * Products filter
 */
NSString *const kTranslationSortByPopularity               = @"6";
NSString *const kTranslationNewestFirst                    = @"7";
NSString *const kTranslationPricestFirst                   = @"8";
NSString *const kTranslationCheapestFirst                  = @"9";

/**
 * General info.
 */
NSString *const kTranslationDataFetchingError              = @"175";
NSString *const kTranslationDataFetchingErrorReason        = @"176";

/**
 * Wishlist.
 */
NSString *const kTranslationWishlistNoProductError         = @"177";
NSString *const kTranslationWishlistNoProductErrorReason   = @"178";
NSString *const kTranslationAddedToWishlist                = @"179";
NSString *const kTranslationWishlist                       = @"180";
NSString *const kTranslationNoWishlistItems                = @"181";
NSString *const kTranslationLoginToRemoveFromWishlist      = @"182";

/*
 * Product details.
 */
NSString *const kTranslationShareWithFriends               = @"183";
NSString *const kTranslationChooseSize                     = @"184";
NSString *const kTranslationChooseColor                    = @"185";
NSString *const kTranslationLoginToAddToWishlist           = @"186";
NSString *const kTranslationLoginToAddToCart               = @"187";
NSString *const kTranslationGoToCart                       = @"188";
NSString *const kTranslationSharePlaceholder               = @"189";
NSString *const kTranslationShareFacebook                  = @"190";
NSString *const kTranslationShareTwitter                   = @"191";
NSString *const kTranslationProperties                     = @"192";

/*
 * Orders.
 */
NSString *const kTranslationOrderID                        = @"83";
NSString *const kTranslationOrderClientName                = @"193";
NSString *const kTranslationOrderDateCreated               = @"194";
NSString *const kTranslationOrderTotalPrice                = @"195";
NSString *const kTranslationOrderShippingName              = @"196";
NSString *const kTranslationOrderTransportPrice            = @"197";
NSString *const kTranslationOrderProductsList              = @"198";
NSString *const kTranslationOrderItemsList                 = @"199";
NSString *const kTranslationOrderElement                   = @"200";



NSString *const kTranslationAll = @"0";
NSString *const kTranslationRecommending = @"2";
NSString *const kTranslationAboutProduct = @"3";
NSString *const kTranslationColorAndSize = @"4";
NSString *const kTranslationSendToAFriend = @"5";
NSString *const kTranslationFilteringOff = @"10";
NSString *const kTranslationOffers = @"11";
NSString *const kTranslationShop = @"12";
NSString *const kTranslationCart = @"13";
NSString *const kTranslationSettings = @"14";
NSString *const kTranslationMyAccount = @"15";
NSString *const kTranslationLoggedOut = @"16";
NSString *const kTranslationMyOrders = @"17";
NSString *const kTranslationEditAccount = @"18";
NSString *const kTranslationLogout = @"19";
NSString *const kTranslationEdit = @"20";
NSString *const kTranslationDelete = @"21";
NSString *const kTranslationOrder = @"22";
NSString *const kTranslationProductInCart = @"23";
NSString *const kTranslationAboutUs = @"26";
NSString *const kTranslationOrderDetail = @"27";
NSString *const kTranslationOrder2 = @"28";
NSString *const kTranslationDateCreated = @"30";
NSString *const kTranslationTotalFormatted = @"31";
NSString *const kTranslationShippingPrice = @"33";
NSString *const kTranslationLoading = @"35";
NSString *const kTranslationAddToCart = @"36";
NSString *const kTranslationAddingToCart = @"37";
NSString *const kTranslationAddingToCartFailed = @"38";
NSString *const kTranslationAddedToCart = @"39";
NSString *const kTranslationColor = @"40";
NSString *const kTranslationSize = @"41";
NSString *const kTranslationAmount = @"42";
NSString *const kTranslationAny = @"43";
NSString *const kTranslationBrand = @"44";
NSString *const kTranslationSendOrder = @"45";
NSString *const kTranslationOrderDetail2 = @"46";
NSString *const kTranslationShippingInformation = @"47";
NSString *const kTranslationShipping2  = @"49";
NSString *const kTranslationName2 = @"51";
NSString *const kTranslationReallyOrder = @"59";
NSString *const kTranslationByOrderingYouAgreeWithOurTermsAndConditions = @"60";
NSString *const kTranslationCancel = @"62";
NSString *const kTranslationEditingCart = @"63";
NSString *const kTranslationChangingShop = @"64";
NSString *const kTranslationFilter = @"65";
NSString *const kTranslationFilterOff = @"66";
NSString *const kTranslationFilterOn = @"67";
NSString *const kTranslationLoggingIn = @"68";
NSString *const kTranslationMakeSureYourInternetConnectionIsAvailableTheServerMayAlsoBeOffline = @"69";
NSString *const kTranslationMore = @"70";
NSString *const kTranslationCashOnDelivery = @"71";
NSString *const kTranslationPleaseFillInAllFields = @"72";
NSString *const kTranslationPrice = @"73";
NSString *const kTranslationProductIsUnavailable = @"74";
NSString *const kTranslationResetFilter = @"75";
NSString *const kTranslationSearch = @"76";
NSString *const kTranslationSearchIn = @"77";
NSString *const kTranslationSendingOrder = @"78";
NSString *const kTranslationSomeFieldsAreNotFilled = @"79";
NSString *const kTranslationSort = @"80";
NSString *const kTranslationSortBy = @"81";
NSString *const kTranslationYourCartIsEmpty = @"82";
NSString *const kTranslationInformation = @"84";
NSString *const kTranslationNotLoggedIn = @"85";
NSString *const kTranslationOrders = @"86";
NSString *const kTranslationError = @"87";
NSString *const kTranslationUserDetails = @"88";
NSString *const kTranslationThereWasAnErrorWhileProcessingYourRequest = @"89";
NSString *const kTranslationSortByNewest = @"90";
NSString *const kTranslationSortByHighestPrice = @"91";
NSString *const kTranslationSortByLowestPrice = @"92";
NSString *const kTranslationOrderNumber = @"93";
NSString *const kTranslationOrderCommand = @"94";
NSString *const kTranslationOrderSent = @"95";
NSString *const kTranslationPopularity = @"96";
NSString *const kTranslationProductDetail = @"99";
NSString *const kTranslationLogInWithFacebook = @"100";
NSString *const kTranslationLogInLater = @"101";
NSString *const kTranslationPleaseFillInEmail = @"102";
NSString *const kTranslationConfirmEmail = @"103";
NSString *const kTranslationConfirmEmailAndEmailFieldsMustMatch = @"104";
NSString *const kTranslationConfirm = @"106";
NSString *const kTranslationLanguage = @"107";
NSString *const kTranslationPleaseSelectYourLanguage = @"108";
NSString *const kTranslationSelectAShop = @"109";
NSString *const kTranslationLoginWithFacebookAndGainAccess = @"110";
NSString *const kTranslationDone = @"111";
NSString *const kTranslationNoOffersHeadline = @"112";
NSString *const kTranslationNoCategoriesHeadline = @"113";
NSString *const kTranslationTapToRefresh = @"114";
NSString *const kTranslationEmptyProductsHeadline = @"116";
NSString *const kTranslationClearSelection = @"117";
NSString *const kTranslationFilterSize = @"118";
NSString *const kTranslationFilterColor = @"119";
NSString *const kTranslationFilterBrand = @"120";
NSString *const kTranslationFilterSearch = @"121";
NSString *const kTranslationFilterCancelSearch = @"122";
NSString *const kTranslationFilterNoFilters = @"123";
NSString *const kTranslationFilterUpdateFilter = @"124";
NSString *const kTranslationErrorDefaultButtonTitle = @"125";

