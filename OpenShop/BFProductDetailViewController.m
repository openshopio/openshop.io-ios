//
//  BFProductDetailViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductDetailViewController.h"
#import "BFAPIManager.h"
#import "UINavigationController+BFCustomTitleView.h"
#import "BFProductVariantColor.h"
#import "BFProductVariantSize.h"
#import "BFProductVariant.h"
#import "StorageManager.h"
#import "BFProductDetailButtonsTableViewCellExtension.h"
#import "NSArray+BFObjectFiltering.h"
#import "BFDataRequestWishlistInfo.h"
#import "BFDataResponseWishlistInfo.h"
#import "User.h"
#import "BFTabBarController.h"
#import <POP.h>
#import <CRToast.h>
#import "BFWishlistViewController.h"
#import "UIImage+BFImageResize.h"
#import "UIFont+BFFont.h"
#import "BFProductDetailRelatedTableViewCellExtension.h"
#import "BFProductDetailDescriptionTableViewCellExtension.h"
#import "NSObject+BFStoryboardInitialization.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"
#import "PersistentStorage.h"
#import "UIWindow+BFOverlays.h"

/**
 * Storyboard onboarding segue identifier.
 */
static NSString *const onboardingSegueIdentifier              = @"onboardingSegue";
/**
 * Storyboard wishlist segue identifier.
 */
static NSString *const wishlistSegueIdentifier                = @"wishlistSegue";
/**
 * Product info related products value identification.
 */
static NSString *const productInfoIncludeRelatedProductsValue = @"related";
/**
 * Navigation item title view update delay.
 */
static CGFloat const navigationItemTitleViewUpdateDelay       = 0.5f;
/**
 * Toast notification message padding.
 */
static CGFloat const toastNotificationPadding                 = 16.0f;
/**
 * Toast notification image size.
 */
static CGFloat const toastNotificationImageSize               = 14.0f;

/**
 * Product detail table view header height.
 */
#define productDetailHeaderHeight CGRectGetHeight([[UIScreen mainScreen] applicationFrame]) * 0.6f
/**
 * Product detail table view footer height.
 */
#define productDetailFooterHeight CGRectGetHeight([[UIScreen mainScreen] applicationFrame]) * 0.2f



@interface BFProductDetailViewController ()

/**
 * Banners table view cell extension.
 */
@property (nonatomic, strong) BFProductDetailButtonsTableViewCellExtension *buttonsExtension;
@property (nonatomic, strong) BFProductDetailRelatedTableViewCellExtension *relatedExtension;
@property (nonatomic, strong) BFProductDetailDescriptionTableViewCellExtension *descriptionExtension;

@property (nonatomic, strong) NSArray<NSURL *> *productImages;

@property (nonatomic, strong) NSArray<BFProductVariantColor *> *productColors;

@property (nonatomic, strong) NSArray<BFProductVariantSize *> *productSizes;

@property (nonatomic, strong) BFProductVariantColor *selectedProductColor;
@property (nonatomic, strong) BFProductVariantSize *selectedProductSize;

@property (nonatomic, strong) UIView *footerView;

@end


@implementation BFProductDetailViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // iOS 8 background fix
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    // setup product info
    [self setupProductInfo];
    
    // title view
    [self updateTitleView];
    
    // empty data set customization
    [self customizeEmptyDataSet];
    
    // table view cell extensions
    [self setupContent];
    
    // update the header view
    [self updateHeaderView:false animated:false];

    // update the footer view
    [self updateFooterView:false];
    
    // fetch data
    [self reloadDataFromNetwork];
}


#pragma mark - Table View Header / Footer

- (BFProductDetailHeaderView *)headerView {
    if(!_headerView) {
        // update header view frame
        _headerView = (BFProductDetailHeaderView *)self.tableView.tableHeaderView;
        CGRect headerFrame = _headerView.frame;
        headerFrame.size.height = productDetailHeaderHeight;
        [_headerView setFrame:headerFrame];
        [self.tableView setTableHeaderView:_headerView];
        
        // update header content
        [self updateHeaderView:false animated:false];

        // relayout
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
    return _headerView;
}

- (UIView *)footerView {
    if(!_footerView) {
        // update footer view frame
        _footerView = self.tableView.tableFooterView;
        CGRect footerFrame = _footerView.frame;
        footerFrame.size.height = productDetailFooterHeight;
        [_footerView setFrame:footerFrame];
        self.tableView.tableFooterView = _footerView;
    }
    return _footerView;
}

- (void)updateHeaderView:(BOOL)finishedLoading animated:(BOOL)animated {
    // header extension
    _headerView.product = self.product;
    _headerView.finishedLoading = finishedLoading;
    
    // product images for variants
    NSMutableOrderedSet *productImages = [[NSMutableOrderedSet alloc] init];
    if(self.product) {
        if(finishedLoading && self.selectedProductColor) {
            NSArray *productVariantsForColor = [self.selectedProductColor.productVariants allObjects];
            NSArray *productVariants = [productVariantsForColor BFN_objectsForAttributeBindings:@{@"product" : self.product}];
            
            for(BFProductVariant *productVariant in productVariants) {
                for(NSString *productVariantImage in productVariant.images) {
                    [productImages addObject:(NSURL *)[NSURL URLWithString:productVariantImage]];
                }
            }
        }
        
        if(![productImages count] && self.product.imageURL) {
            [productImages addObject:(NSURL *)[NSURL URLWithString:(NSString *)self.product.imageURL]];
        }
    }
    _headerView.images = [productImages array];
    // update content
    [_headerView updateContent];
    
    if(animated) {
        [_headerView animatePageControl];
    }
    
    self.tableView.tableHeaderView = self.product ? _headerView : nil;
}

- (void)updateFooterView:(BOOL)finishedLoading {
    self.tableView.tableFooterView = self.product && !finishedLoading ? self.footerView : nil;
}


#pragma mark - Content Update

- (void)setupContent {
    [self.headerView setupContentWithDelegate:self];
    [self setupExtensions];
}

- (void)updateProductDetails:(BFProduct *)product {
    if(product) {
        self.product = product;
        // colors and sizes
        self.productColors = [[StorageManager defaultManager]findProductVariantColorsForProducts:@[self.product] withSizes:nil];
        self.selectedProductColor = self.productColors.count ? [self.productColors firstObject] : nil;
        self.productSizes = [[StorageManager defaultManager]findProductVariantSizesForProducts:@[self.product] withColors:self.selectedProductColor ? @[self.selectedProductColor] : nil];
        self.selectedProductSize = self.productSizes.count ? [self.productSizes firstObject] : nil;
    }
}

- (void)updateTitleView {
    // product brand title
    if (self.product && self.product.brand && self.product.brand.length) {
        [self.navigationController setCustomTitleViewText:(NSString *)self.product.brand];
    }
    else {
        [self.navigationController setCustomTitleViewText:(NSString *)self.productInfo.resultsTitle];
    }
}

- (void)updateWishlistView {
    BFDataRequestWishlistInfo *wishlistInfo = [[BFDataRequestWishlistInfo alloc]init];
    wishlistInfo.productVariantID = self.product.productID;
    
    // check if product variant is in wishlist
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager]isProductVariantInWishlist:wishlistInfo completionBlock:^(id response, NSError *error) {
        __typeof__(weakSelf) strongSelf = weakSelf;
        if(!error && response) {
            BFDataResponseWishlistInfo *result = [BFDataResponseWishlistInfo deserializedModelFromDictionary:response error:&error];
            if(!error && result) {
                [strongSelf.headerView updateWishlist:result.isInWishlist ? [result.isInWishlist boolValue] : false hidden:false];
                return;
            }
        }
        
        [strongSelf.headerView updateWishlist:false hidden:true];
    }];
}


#pragma mark - Product Info

- (void)setupProductInfo {
    if(!self.productInfo) {
        self.productInfo = [[BFDataRequestProductInfo alloc]init];
    }
    
    if(self.wishlistItem && self.wishlistItem.productVariant && self.wishlistItem.productVariant.product) {
        self.product = self.wishlistItem.productVariant.product;
    }
    
    if(self.product) {
        self.productInfo.resultsTitle = self.product.name;
        self.productInfo.productID = self.product.productID;
    }
    
    if(!self.productInfo.resultsTitle) {
        self.productInfo.resultsTitle = BFLocalizedString(kTranslationProductDetail, @"Product detail");
    }
    
    if(!self.productInfo.include) {
        self.productInfo.include = productInfoIncludeRelatedProductsValue;
    }
}


#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // product action buttons extension
    _buttonsExtension = [[BFProductDetailButtonsTableViewCellExtension alloc]initWithTableViewController:self];
    _buttonsExtension.finishedLoading = false;
    
    // product description extension
    _descriptionExtension = [[BFProductDetailDescriptionTableViewCellExtension alloc]initWithTableViewController:self];
    _descriptionExtension.finishedLoading = false;
    
    // related products extension
    _relatedExtension = [[BFProductDetailRelatedTableViewCellExtension alloc]initWithTableViewController:self];
    _relatedExtension.finishedLoading = false;
    
    [self setExtensions:@[_buttonsExtension, _descriptionExtension, _relatedExtension]];
}

- (void)updateExtensions:(BOOL)finishedLoading animated:(BOOL)animated {
    [self updateButtonsExtensionData:finishedLoading];
    [self updateDescriptionExtensionData:finishedLoading];
    [self updateRelatedExtensionData:finishedLoading];
    
    if (animated && finishedLoading) {
        [self reloadExtensions:@[_buttonsExtension, _descriptionExtension, _relatedExtension] withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        [self.tableView reloadData];
    }
}

- (void)updateButtonsExtensionData:(BOOL)finishedLoading {
    _buttonsExtension.product = self.product;
    // product colors
    _buttonsExtension.productColors = self.productColors;
    _buttonsExtension.selectedProductColor = self.selectedProductColor;
    // product sizes
    _buttonsExtension.productSizes = self.productSizes;
    _buttonsExtension.selectedProductSize = self.selectedProductSize;
    // finished loading flag
    _buttonsExtension.finishedLoading = finishedLoading;
}

- (void)updateDescriptionExtensionData:(BOOL)finishedLoading {
    _descriptionExtension.product = self.product;
    // finished loading flag
    _descriptionExtension.finishedLoading = finishedLoading;
}

- (void)updateRelatedExtensionData:(BOOL)finishedLoading {
    _relatedExtension.relatedProducts = self.product.relatedProducts ? [self.product.relatedProducts allObjects] : @[];
    // finished loading flag
    _relatedExtension.finishedLoading = finishedLoading;
}


#pragma mark - Data Fetching

- (void)reloadDataFromNetwork {
    // data fetching flag
    self.loadingData = true;
    
    // fetch banners
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager]findProductDetailsWithInfo:self.productInfo completionBlock:^(NSArray *records, id  customResponse, NSError * error) {
        __typeof__(weakSelf) strongSelf = weakSelf;
        // error results
        if(error) {
            BFError *customError = [BFError errorWithError:error];
            __weak __typeof__(strongSelf) weakSelf = strongSelf;
            [customError showAlertFromSender:strongSelf withCompletionBlock:^(BOOL recovered, NSNumber *optionIndex) {
                [weakSelf.navigationController popViewControllerAnimated:true];
            }];
        }
        else if(records.count) {
            // update product details
            [strongSelf updateProductDetails:[records firstObject]];
            // update title view
            [strongSelf performSelector:@selector(updateTitleView) withObject:nil afterDelay:navigationItemTitleViewUpdateDelay];
            
            // update extensions
            [strongSelf updateExtensions:true animated:!strongSelf.tableView.emptyDataSetVisible];
            // update header / footer view
            [strongSelf updateHeaderView:true animated:true];
            [strongSelf updateFooterView:true];
            
            // update wishlist view
            [strongSelf updateWishlistView];
        }
        // data fetching flag
        strongSelf.loadingData = false;
    }];
}


#pragma mark - DZNEmptyDataSetSource Customization

- (void)customizeEmptyDataSet {
    self.emptyDataTitle = BFLocalizedString(kTranslationDataFetchingError, @"There was an error while fetching the data.");
}


#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return (self.product == nil);
}


#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    if(viewController == [BFOnboardingViewController class]) {
        BFTabBarController *tabBarController = (BFTabBarController *)self.tabBarController;
        // present the onboarding view from the tab bar controller
        [tabBarController performSegueWithIdentifier:onboardingSegueIdentifier sender:self];
    }
    else if(viewController == [BFProductDetailViewController class]) {
        BFProductDetailViewController *productDetailController = (BFProductDetailViewController *)[self BFN_mainStoryboardClassInstanceWithClass:[BFProductDetailViewController class]];
        self.segueParameters = dictionary;
        
        [self applySegueParameters:productDetailController];
        [self.navigationController pushViewController:productDetailController animated:YES];
    }
}


#pragma mark - BFProductDetailHeaderViewDelegate

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self presentViewController:viewController animated:animated completion:nil];
}

#pragma mark - Wishlist methods

- (void)wishlistButtonClicked:(BFWishlistButtonView *)wishlistButtonView {
   BFProductVariant *productVariant = [[StorageManager defaultManager]findProductVariantForProduct:(BFProduct *)self.product withColor:self.selectedProductColor size:self.selectedProductSize];
    
   if(!productVariant) {
       BFError *customError = [BFError errorWithCode:BFErrorCodeWishlistNoProduct];
       [customError showAlertFromSender:self];
   }
   else {
       // add product variant to the wishlist
       if([User isLoggedIn]) {
           [self addProductVariant:productVariant toWishlist:wishlistButtonView];
       }
       // request user login
       else {
           BFTabBarController *tabBarController = (BFTabBarController *)self.tabBarController;
           if(tabBarController) {
               __weak __typeof__(tabBarController) weakTabBarController = tabBarController;
               __weak __typeof__(self) weakSelf = self;
               tabBarController.completionBlock = ^(BOOL skipped) {
                   [weakTabBarController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
                   [weakSelf addProductVariant:productVariant toWishlist:wishlistButtonView];
               };
               tabBarController.didAppearBlock = ^(BFOnboardingViewController *controller) {
                   [controller.view.window showToastWarningMessage:BFLocalizedString(kTranslationLoginToAddToWishlist, @"Please login to add the product to the wishlist") withCompletion:nil];
               };
               // present the onboarding view from the tab bar controller
               [tabBarController performSegueWithIdentifier:onboardingSegueIdentifier sender:self];
           }
       }
   }
}

- (void)addProductVariant:(BFProductVariant *)productVariant toWishlist:(BFWishlistButtonView *)wishlistButtonView {
    [wishlistButtonView setRequestState:true];
    
    // shrink the original wishlist button (heart image)
    __weak __typeof__(self) weakSelf = self;
    [wishlistButtonView shrinkButtonWithCompletionHandler:^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            BFDataRequestWishlistInfo *wishlistInfo = [[BFDataRequestWishlistInfo alloc]init];
            wishlistInfo.productVariantID = productVariant.productVariantID;
            
            BFAPIInfoCompletionBlock wishlistRequestCompletion = ^(id response, NSError *error) {
                __typeof__(weakSelf) strongSelf = weakSelf;
                if(error) {
                    BFError *customError = [BFError errorWithError:error];
                    [customError showAlertFromSender:strongSelf];
                }
                else {
                    wishlistButtonView.isInWishlist = !wishlistButtonView.isInWishlist;
                }
                [strongSelf finishWishlistRequest:wishlistButtonView withResult:(error == nil)];
            };
            // update the wishlist
            if (!wishlistButtonView.isInWishlist) {
                [[BFAPIManager sharedManager] addProductVariantToWishlistWithInfo:wishlistInfo completionBlock:wishlistRequestCompletion];
            }
            else {
                [[BFAPIManager sharedManager] deleteProductVariantInWishlistWithInfo:wishlistInfo completionBlock:wishlistRequestCompletion];
            }
        }
    }];
}

- (void)finishWishlistRequest:(BFWishlistButtonView *)wishlistButtonView withResult:(BOOL)success {
    [wishlistButtonView.activityIndicator stopAnimating];

    // enlarge animation
    __weak __typeof__(self) weakSelf = self;
    [wishlistButtonView enlargeButtonWithStartHandler:^(POPAnimation *anim) {
        // scale animation
        [wishlistButtonView scaleButtonWithStartHandler:^(POPAnimation *anim) {
            // call a completion handler
            if (success && [wishlistButtonView isInWishlist]) {
                __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf showWishlistSuccessToastMessage];
            }
            
            [wishlistButtonView setRequestState:false];
        } didReachToValueHandler:^(POPAnimation *anim) {
            if (success) {
                [wishlistButtonView setSelected:[wishlistButtonView isInWishlist]];
                [[NSNotificationCenter defaultCenter]BFN_postAsyncNotificationName:BFWishlistDidChangeNotification];
            }
        }];
    }];
}

- (void)showWishlistSuccessToastMessage {
    __weak __typeof__(self) weakSelf = self;
    CRToastInteractionResponder *interactionResponder = [CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTapOnce automaticallyDismiss:YES block:^(CRToastInteractionType interactionType) {
        [weakSelf presentWishlistViewController];
    }];
    
    [self.view.window showToastMessage:BFLocalizedString(kTranslationAddedToWishlist, @"Added to the wishlist")
               withOptions:@{
                             kCRToastFontKey: [UIFont BFN_robotoMediumWithSize:12],
                             kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                             kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight),
                             kCRToastImageKey: [[UIImage imageNamed:@"WishlistIconUnselectedWhite"]imageFitInSize:CGSizeMake(toastNotificationImageSize, toastNotificationImageSize)],
                             kCRToastInteractionRespondersKey:@[interactionResponder],
                             kCRToastNotificationPreferredPaddingKey: @(toastNotificationPadding),
                            } completion:nil];
}

- (void)presentWishlistViewController {
    [((BFTabBarController *)self.tabBarController) setSelectedItem:BFTabBarItemMore withPopToRootViewController:YES animated:YES];
}

#pragma mark - Custom Appearance

+ (void)customizeAppearance {
    // no separator
    [UITableView appearanceWhenContainedIn:self, nil].separatorColor = [UIColor clearColor];
    // grouped table view background
    [[UITableView appearanceWhenContainedIn:self, nil] setBackgroundView:nil];
    [[UITableView appearanceWhenContainedIn:self, nil] setBackgroundColor:[UIColor whiteColor]];
    // remove table view cell separators for empty cells
    [UITableView appearanceWhenContainedIn:self, nil].tableFooterView = [UIView new];
}


@end
