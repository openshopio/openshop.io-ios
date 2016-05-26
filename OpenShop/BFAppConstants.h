//
//  BFAppConstants.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import ObjectiveC.runtime;
#import "StorageManager.h"

/**
 * Localization macro shortcut for simple lookup of fetched translations.
 */
#define BFLocalizedString(key, val) [[StorageManager defaultManager]findTranslationStringWithKey:key defaultValue:val]

/**
 * iOS versions macros to determine availability of specific implementation.
 */
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

/**
 * `BFAppConstants` is a wrapper for global application constants. These constants are also
 * used for translations mapping to their equivalent keys when fetched from remote API.
 */
@interface BFAppConstants : NSObject

@end


/**
 * Minimum number of method arguments (target and selector).
 */
extern NSInteger const kMinNumberOfMethodArguments;

/**
 **********************************************************
 * Notification names.
 **********************************************************
 */

/**
 * Notification name posted when user access token was changed.
 */
extern NSString *const BFKeyStoreDidChangeAccessTokenChangedNotification;
/**
 * Notification name posted when user data was saved.
 */
extern NSString *const BFUserDidSaveNotification;
/**
 * Notification name posted when user was logged out.
 */
extern NSString *const BFUserDidChangeNotification;
/**
 * Notification name posted when user authentication is done.
 */
extern NSString *const BFUserDidAuthenticateNotification;
/**
 * Notification name posted when user shopping cart was changed.
 */
extern NSString *const BFCartDidChangeNotification;
/**
 * Notification name posted when user shopping cart needs synchronization.
 */
extern NSString *const BFCartWillSynchronizeNotification;
/**
 * Notification name posted when shopping cart badge value was changed.
 */
extern NSString *const BFCartBadgeValueDidChangeNotification;
/**
 * Notification name posted when application language was changed.
 */
extern NSString *const BFLanguageDidChangeNotification;
/**
 * Notification name posted when device was registered at APNS.
 */
extern NSString *const BFDeviceDidRegisterNotification;
/**
 * Notification name posted when user wishlist was changed.
 */
extern NSString *const BFWishlistDidChangeNotification;

/**
 **********************************************************
 * Translation strings keys mapping.
 **********************************************************
 */

/**
 * User's onboarding process.
 */
extern NSString *const kTranslationChooseCountry;
extern NSString *const kTranslationWhereYouWantToShop;
extern NSString *const kTranslationCzechRepublic;
extern NSString *const kTranslationSlovakRepublic;
extern NSString *const kTranslationCzechLanguage;
extern NSString *const kTranslationSlovakLanguage;

/**
 * User's onboarding - login, registration.
 */
extern NSString *const kTranslationEnterEmailAndPassword;
extern NSString *const kTranslationDidYouForgetPassword;
extern NSString *const kTranslationLogin;
extern NSString *const kTranslationPasswordRetrieval;
extern NSString *const kTranslationLoginWithEmail;
extern NSString *const kTranslationPassword;
extern NSString *const kTranslationPasswordRetrievalInProgress;
extern NSString *const kTranslationNewPasswordWasSentToYourEmail;
extern NSString *const kTranslationErrorIncompleteInput;
extern NSString *const kTranslationErrorGeneric;
extern NSString *const kTranslationErrorFacebookLogin;
extern NSString *const kTranslationErrorInvalidInputEmail;
extern NSString *const kTranslationInput;
extern NSString *const kTranslationLoginError;
extern NSString *const kTranslationLoginErrorCredentials;
extern NSString *const kTranslationRegister;
extern NSString *const kTranslationDontHaveAnAccount;
extern NSString *const kTranslationMan;
extern NSString *const kTranslationWoman;
extern NSString *const kTranslationRegistrationError;
extern NSString *const kTranslationRegistrationErrorCredentials;
extern NSString *const kTranslationRegistering;
extern NSString *const kTranslationLoginToOpenShop;
extern NSString *const kTranslationSkip;
/**
 * Push notification permissions.
 */
extern NSString *const kTranslationWouldYouLikeToBeInformed;
extern NSString *const kTranslationYesPlease;
extern NSString *const kTranslationNoThanks;

/**
 * Products categories.
 */
extern NSString *const kTranslationMen;
extern NSString *const kTranslationWomen;
extern NSString *const kTranslationDesign;
extern NSString *const kTranslationCatalogue;
extern NSString *const kTranslationPopular;
extern NSString *const kTranslationSale;

/**
 * Products offers.
 */
extern NSString *const kTranslationJustArrived;

/**
 * APNS.
 */
extern NSString *const kTranslationHide;
extern NSString *const kTranslationBrowseHere;

/**
 * Shopping cart.
 */
extern NSString *const kTranslationShoppingCart;
extern NSString *const kTranslationContinue;
extern NSString *const kTranslationEmptyCartHeadline;
extern NSString *const kTranslationEmptyCartSubheadline;
extern NSString *const kTranslationDiscounts;
extern NSString *const kTranslationProductsInCart;
extern NSString *const kTranslationProducts;
extern NSString *const kTranslationPieces;
extern NSString *const kTranslationApplyingDiscountCode;
extern NSString *const kTranslationApplyDiscountCode;
extern NSString *const kTranslationEnterDiscountCode;
extern NSString *const kTranslationDiscountCode;
extern NSString *const kTranslationProceedToShipping;

/**
 * Edit product in shopping cart
 */
extern NSString *const kTranslationEditProduct;
extern NSString *const kTranslationQuantity;
extern NSString *const kTranslationChooseQuantity;

/**
 * Order form.
 */
extern NSString *const kTranslationShippingAndPayment;
extern NSString *const kTranslationContactInformation;
extern NSString *const kTranslationName;
extern NSString *const kTranslationNamePlaceholder;
extern NSString *const kTranslationEmail;
extern NSString *const kTranslationEmailPlaceholder;
extern NSString *const kTranslationPhoneNumber;
extern NSString *const kTranslationPhoneNumberPlaceholder;
extern NSString *const kTranslationStreet;
extern NSString *const kTranslationStreetPlaceholder;
extern NSString *const kTranslationHouseNo;
extern NSString *const kTranslationHouseNoPlaceholder;
extern NSString *const kTranslationCity;
extern NSString *const kTranslationCityPlaceholder;
extern NSString *const kTranslationPostalCode;
extern NSString *const kTranslationPostalCodePlaceholder;
extern NSString *const kTranslationNote;
extern NSString *const kTranslationPleaseFillInShipping;
extern NSString *const kTranslationPleaseFillInPayment;
extern NSString *const kTranslationVatIncluded;
extern NSString *const kTranslationByOrderingYouAgreeWithOur;
extern NSString *const kTranslationTermsAndConditions;

/**
 * Shipping, Payment
 */
extern NSString *const kTranslationShipping;
extern NSString *const kTranslationPersonalPickup;
extern NSString *const kTranslationPayment;
extern NSString *const kTranslationPaymentMethod;

/**
 * Order Summary
 */
extern NSString *const kTranslationSummary;
extern NSString *const kTranslationYourOrder;
extern NSString *const kTranslationYourOrderHasBeenSent;
extern NSString *const kTranslationWaitForSMS;
extern NSString *const kTranslationTotal;
extern NSString *const kTranslationAddress;
extern NSString *const kTranslationDismiss;

/**
 * Products searching.
 */
extern NSString *const kTranslationWhoSeeksFinds;
extern NSString *const kTranslationLastSearchedQueries;
extern NSString *const kTranslationMostSearchedQueries;
extern NSString *const kTranslationNoSearchQueries;
extern NSString *const kTranslationSearchSuggestions;
extern NSString *const kTranslationCategory;

/**
 * More section.
 */
extern NSString *const kTranslationOpenShop;
extern NSString *const kTranslationMyWishlist;
extern NSString *const kTranslationBranches;
extern NSString *const kTranslationCountryAndCurrency;
extern NSString *const kTranslationUserProfile;
extern NSString *const kTranslationClose;

/*
 * Orders history.
 */
extern NSString *const kTranslationNoOrders;
extern NSString *const kTranslationGoShopping;

/*
 * Branches
 */
extern NSString *const kTranslationNavigateToBranch;

/**
 * Settings.
 */
extern NSString *const kTranslationNoSettings;
extern NSString *const kTranslationGoBack;
extern NSString *const kTranslationCountry;

/**
 * User details.
 */
extern NSString *const kTranslationUserDetailsName;
extern NSString *const kTranslationUserDetailsEmail;
extern NSString *const kTranslationUserDetailsPhone;
extern NSString *const kTranslationUserDetailsStreet;
extern NSString *const kTranslationUserDetailsHouseNumber;
extern NSString *const kTranslationUserDetailsCity;
extern NSString *const kTranslationUserDetailsZip;
extern NSString *const kTranslationUserDetailsOldPassword;
extern NSString *const kTranslationUserDetailsNewPassword;
extern NSString *const kTranslationUserDetailsConfirmPassword;
extern NSString *const kTranslationUserDetailsPasswordChange;
extern NSString *const kTranslationUserDetailsConfirm;
extern NSString *const kTranslationChangePassword;
extern NSString *const kTranslationPasswordsMatch;

/**
 * Empty data set.
 */
extern NSString *const kTranslationNoItems;
extern NSString *const kTranslationPressForUpdate;
extern NSString *const kTranslationGoToCategories;
extern NSString *const kTranslationNoProducts;

/**
 * Products filter
 */
extern NSString *const kTranslationSortByPopularity;
extern NSString *const kTranslationNewestFirst;
extern NSString *const kTranslationPricestFirst;
extern NSString *const kTranslationCheapestFirst;
extern NSString *const kTranslationCancelFilter;
extern NSString *const kTranslationApplyFilter;

/**
 * General info.
 */
extern NSString *const kTranslationDataFetchingError;
extern NSString *const kTranslationDataFetchingErrorReason;

/**
 * Wishlist.
 */
extern NSString *const kTranslationWishlistNoProductError;
extern NSString *const kTranslationWishlistNoProductErrorReason;
extern NSString *const kTranslationAddedToWishlist;
extern NSString *const kTranslationWishlist;
extern NSString *const kTranslationNoWishlistItems;
extern NSString *const kTranslationLoginToRemoveFromWishlist;

/*
 * Product details.
 */
extern NSString *const kTranslationShareWithFriends;
extern NSString *const kTranslationChooseSize;
extern NSString *const kTranslationChooseColor;
extern NSString *const kTranslationLoginToAddToWishlist;
extern NSString *const kTranslationLoginToAddToCart;
extern NSString *const kTranslationGoToCart;
extern NSString *const kTranslationSharePlaceholder;
extern NSString *const kTranslationShareFacebook;
extern NSString *const kTranslationShareTwitter;
extern NSString *const kTranslationProperties;
extern NSString *const kTranslationOrderItemsList;
extern NSString *const kTranslationCartNoProductError;
extern NSString *const kTranslationNoProductVariantErrorReason;

/*
 * Orders.
 */
extern NSString *const kTranslationOrderID;
extern NSString *const kTranslationOrderClientName;
extern NSString *const kTranslationOrderDateCreated;
extern NSString *const kTranslationOrderTotalPrice;
extern NSString *const kTranslationOrderShippingName;
extern NSString *const kTranslationOrderTransportPrice;
extern NSString *const kTranslationOrderProductsList;
extern NSString *const kTranslationOrderElement;


extern NSString *const kTranslationAll;
extern NSString *const kTranslationRecommended;
extern NSString *const kTranslationAboutProduct;
extern NSString *const kTranslationColorAndSize;
extern NSString *const kTranslationSendToAFriend;
extern NSString *const kTranslationFilteringOff;
extern NSString *const kTranslationOffers;
extern NSString *const kTranslationShop;
extern NSString *const kTranslationCart;
extern NSString *const kTranslationSettings;
extern NSString *const kTranslationMyAccount;
extern NSString *const kTranslationLoggedOut;
extern NSString *const kTranslationMyOrders;
extern NSString *const kTranslationEditAccount;
extern NSString *const kTranslationLogout;
extern NSString *const kTranslationEdit;
extern NSString *const kTranslationDelete;
extern NSString *const kTranslationOrder;
extern NSString *const kTranslationProductInCart;
extern NSString *const kTranslationTotal;
extern NSString *const kTranslationAboutUs;
extern NSString *const kTranslationOrderDetail;
extern NSString *const kTranslationOrder2;
extern NSString *const kTranslationDateCreated;
extern NSString *const kTranslationTotalFormatted;
extern NSString *const kTranslationShipping;
extern NSString *const kTranslationShippingPrice;
extern NSString *const kTranslationProductsList;
extern NSString *const kTranslationLoading;
extern NSString *const kTranslationAddToCart;
extern NSString *const kTranslationAddingToCart;
extern NSString *const kTranslationAddingToCartFailed;
extern NSString *const kTranslationAddedToCart;
extern NSString *const kTranslationColor;
extern NSString *const kTranslationSize;
extern NSString *const kTranslationAmount;
extern NSString *const kTranslationAny;
extern NSString *const kTranslationBrand;
extern NSString *const kTranslationSendOrder;
extern NSString *const kTranslationOrderDetail2;
extern NSString *const kTranslationShippingInformation;
extern NSString *const kTranslationPayment;
extern NSString *const kTranslationShipping2;
extern NSString *const kTranslationShippingAndPayment;
extern NSString *const kTranslationName2;
extern NSString *const kTranslationReallyOrder;
extern NSString *const kTranslationByOrderingYouAgreeWithOurTermsAndConditions;
extern NSString *const kTranslationTermsAndConditions;
extern NSString *const kTranslationCancel;
extern NSString *const kTranslationEditingCart;
extern NSString *const kTranslationChangingShop;
extern NSString *const kTranslationFilter;
extern NSString *const kTranslationFilterOff;
extern NSString *const kTranslationFilterOn;
extern NSString *const kTranslationLoggingIn;
extern NSString *const kTranslationMakeSureYourInternetConnectionIsAvailableTheServerMayAlsoBeOffline;
extern NSString *const kTranslationMore;
extern NSString *const kTranslationCashOnDelivery;
extern NSString *const kTranslationPleaseFillInAllFields;
extern NSString *const kTranslationPrice;
extern NSString *const kTranslationProductIsUnavailable;
extern NSString *const kTranslationResetFilter;
extern NSString *const kTranslationSearch;
extern NSString *const kTranslationSearchIn;
extern NSString *const kTranslationSendingOrder;
extern NSString *const kTranslationSomeFieldsAreNotFilled;
extern NSString *const kTranslationSort;
extern NSString *const kTranslationSortBy;
extern NSString *const kTranslationYourCartIsEmpty;
extern NSString *const kTranslationInformation;
extern NSString *const kTranslationNotLoggedIn;
extern NSString *const kTranslationOrders;
extern NSString *const kTranslationError;
extern NSString *const kTranslationUserDetails;
extern NSString *const kTranslationThereWasAnErrorWhileProcessingYourRequest;
extern NSString *const kTranslationSortByNewest;
extern NSString *const kTranslationSortByHighestPrice;
extern NSString *const kTranslationSortByLowestPrice;
extern NSString *const kTranslationOrderNumber;
extern NSString *const kTranslationOrderCommand;
extern NSString *const kTranslationOrderSent;
extern NSString *const kTranslationPopularity;
extern NSString *const kTranslationProductDetail;
extern NSString *const kTranslationLogInWithFacebook;
extern NSString *const kTranslationLogInLater;
extern NSString *const kTranslationPleaseFillInEmail;
extern NSString *const kTranslationConfirmEmail;
extern NSString *const kTranslationConfirmEmailAndEmailFieldsMustMatch;
extern NSString *const kTranslationConfirm;
extern NSString *const kTranslationLanguage;
extern NSString *const kTranslationPleaseSelectYourLanguage;
extern NSString *const kTranslationSelectAShop;
extern NSString *const kTranslationLoginWithFacebookAndGainAccess;
extern NSString *const kTranslationDone;
extern NSString *const kTranslationNoOffersHeadline;
extern NSString *const kTranslationNoCategoriesHeadline;
extern NSString *const kTranslationTapToRefresh;
extern NSString *const kTranslationEmptyProductsHeadline;
extern NSString *const kTranslationClearSelection;
extern NSString *const kTranslationFilterSize;
extern NSString *const kTranslationFilterColor;
extern NSString *const kTranslationFilterBrand;
extern NSString *const kTranslationFilterSearch;
extern NSString *const kTranslationFilterCancelSearch;
extern NSString *const kTranslationFilterNoFilters;
extern NSString *const kTranslationFilterUpdateFilter;
extern NSString *const kTranslationErrorDefaultButtonTitle;


