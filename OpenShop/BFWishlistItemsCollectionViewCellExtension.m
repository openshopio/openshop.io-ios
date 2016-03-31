//
//  BFWishlistItemsCollectionViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFWishlistItemsCollectionViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewController.h"
#import "UIImage+BFImageResize.h"
#import <UIImageView+AFNetworking.h>
#import "BFProductVariant.h"
#import "BFWishlistCollectionViewCell.h"
#import "BFAppPreferences.h"
#import "BFCollectionViewLayout.h"
#import "BFProductDetailViewController.h"
#import "BFError.h"
#import "User.h"
#import "BFTabBarController.h"
#import "BFAPIManager.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "UIWindow+BFOverlays.h"

/**
 * Wishlist item collection view cell reuse identifier.
 */
static NSString *const wishlistItemReuseIdentifier                   = @"BFWishlistItemCollectionViewCellIdentifier";
/**
 * Wishlist items loading footer view reuse identifier.
 */
static NSString *const wishlistItemsLoadingFooterViewReuseIdentifier = @"BFWishlistItemsLoadingFooterViewIdentifier";
/**
 * Wishlist items loading footer view nib file name.
 */
static NSString *const wishlistItemsLoadingFooterViewNibName         = @"BFLoadingCollectionReusableView";
/**
 * Wishlist items loading footer view height.
 */
static CGFloat const wishlistItemsLoadingFooterViewHeight            = 50.0f;
/**
 * Presenting segue wishlist item parameter.
 */
static NSString *const segueParameterWishlistItem                    = @"wishlistItem";
/**
 * Storyboard onboarding segue identifier.
 */
static NSString *const onboardingSegueIdentifier                     = @"onboardingSegue";


@interface BFWishlistItemsCollectionViewCellExtension ()

/**
 * Wishlist items calculated height cache.
 */
@property (nonatomic, strong) NSMutableDictionary *wishlistItemsSizeCache;

@end


@implementation BFWishlistItemsCollectionViewCellExtension


#pragma mark - Initialization

- (instancetype)initWithCollectionViewController:(BFCollectionViewController *)viewController {
    self = [super initWithCollectionViewController:viewController];
    if (self) {
        self.wishlistItems = @[];
        self.showsFooter = false;
        self.wishlistItemsSizeCache = [NSMutableDictionary new];
    }
    return self;
}

- (void)didLoad {
    // register footer view
    [self.collectionView registerNib:[UINib nibWithNibName:wishlistItemsLoadingFooterViewNibName bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:wishlistItemsLoadingFooterViewReuseIdentifier];
}

- (void)setShowsFooter:(BOOL)showsFooter {
    _showsFooter = self.wishlistItems.count && showsFooter;
}


#pragma mark - UICollectionViewDataSource

- (NSUInteger)getNumberOfItems {
    return [self.wishlistItems count];
}

- (UICollectionViewCell *)getCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BFWishlistCollectionViewCell *cell = (BFWishlistCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:wishlistItemReuseIdentifier forIndexPath:indexPath];
    
    if(!cell) {
        cell = [[BFWishlistCollectionViewCell alloc]init];
    }
    // wishlist item
    BFWishlistItem *wishlistItem = [self.wishlistItems objectAtIndex:indexPath.row];
    BFProductVariant *productVariant = wishlistItem.productVariant;
    
    if(productVariant && productVariant.product) {
        cell.headerlabel.text = productVariant.product.name;
        cell.subheaderLabel.attributedText = [productVariant.product priceAndDiscountFormattedWithPercentage:NO];
        if(productVariant.product.imageURL) {
           [cell.imageContentView setImageWithURL:(NSURL *)[NSURL URLWithString:(NSString *)productVariant.product.imageURL] placeholderImage:cell.imageContentView.placeholderImage];
        }
        // select wishlist button
        cell.wishlistButtonView.isInWishlist = true;
        [cell.wishlistButtonView setSelected:true];
        // wishlist button selection callback
        __weak __typeof__(self) weakSelf = self;
        cell.wishlistButtonView.selectionBlock = ^(BFWishlistButtonView *wishlistButtonView) {
            [weakSelf wishlistButtonClicked:wishlistButtonView onItem:wishlistItem];
        };
    }

    return cell;
}

- (IBAction)wishlistButtonClicked:(BFWishlistButtonView *)wishlistButtonView onItem:(BFWishlistItem *)wishlistItem {
    BFProductVariant *productVariant = wishlistItem.productVariant;
    // no product variant for specified wishlist item
    if(!productVariant) {
        BFError *customError = [BFError errorWithCode:BFErrorCodeWishlistNoProduct];
        [customError showAlertFromSender:self];
    }
    else {
        // remove item from wishlist
        if([User isLoggedIn]) {
            [self removeProductVariant:productVariant fromWishlist:wishlistButtonView];
        }
        // request user login
        else {
            BFTabBarController *tabBarController = (BFTabBarController *)self.collectionViewController.tabBarController;
            if(tabBarController) {
                __weak __typeof__(tabBarController) weakTabBarController = tabBarController;
                __weak __typeof__(self) weakSelf = self;
                tabBarController.skipBlock = ^(NSArray *controllers, NSInteger current) {
                    [weakTabBarController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
                };
                tabBarController.completionBlock = ^(BOOL skipped) {
                    [weakTabBarController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
                    [weakSelf removeProductVariant:productVariant fromWishlist:wishlistButtonView];
                };
                tabBarController.didAppearBlock = ^(BFOnboardingViewController *controller) {
                    [controller.view.window showToastWarningMessage:BFLocalizedString(kTranslationLoginToRemoveFromWishlist, @"Please login to remove the product from the wishlist") withCompletion:nil];
                };
                // present the onboarding view from the tab bar controller
                [tabBarController performSegueWithIdentifier:onboardingSegueIdentifier sender:self];
            }
        }
    }
}


- (void)removeProductVariant:(BFProductVariant *)productVariant fromWishlist:(BFWishlistButtonView *)wishlistButtonView {
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
            [[BFAPIManager sharedManager] deleteProductVariantInWishlistWithInfo:wishlistInfo completionBlock:wishlistRequestCompletion];
        }
    }];
}


- (void)finishWishlistRequest:(BFWishlistButtonView *)wishlistButtonView withResult:(BOOL)success {
    // stop activity indicator
    [wishlistButtonView.activityIndicator stopAnimating];
    [wishlistButtonView enlargeButtonWithStartHandler:^(POPAnimation *anim) {
        [wishlistButtonView scaleButtonWithStartHandler:^(POPAnimation *anim) {
            [wishlistButtonView setRequestState:false];
        } didReachToValueHandler:^(POPAnimation *anim) {
            if (success) {
                // update selection
                [wishlistButtonView setSelected:[wishlistButtonView isInWishlist]];
                // notify with the changes
                [[NSNotificationCenter defaultCenter]BFN_postAsyncNotificationName:BFWishlistDidChangeNotification];
            }
        }];
    }];
}


- (UICollectionReusableView *)getViewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:wishlistItemsLoadingFooterViewReuseIdentifier forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

- (CGSize)layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return self.showsFooter ? CGSizeMake(self.collectionView.frame.size.width, wishlistItemsLoadingFooterViewHeight) : CGSizeZero;
}


#pragma mark - UICollectionViewDelegate

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // wishlist item
    BFWishlistItem *wishlistItem = [self.wishlistItems objectAtIndex:indexPath.row];

    if(wishlistItem) {
        [self.collectionViewController performSegueWithViewController:[BFProductDetailViewController class] params:@{segueParameterWishlistItem : wishlistItem}];
    }

}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if([collectionViewLayout isKindOfClass:[BFCollectionViewLayout class]]) {
        // cached height exists
        if([self.wishlistItemsSizeCache objectForKey:indexPath]) {
            return [((NSValue *)[self.wishlistItemsSizeCache objectForKey:indexPath]) CGSizeValue];
        }
        // calculate wishlist item height
        CGSize calculatedSize = [((BFCollectionViewLayout *)collectionViewLayout) itemSizeInCollectionView:self.collectionView];
        [self.wishlistItemsSizeCache setObject:[NSValue valueWithCGSize:calculatedSize] forKey:indexPath];
        
        return calculatedSize;
    }
    return CGSizeZero;
}



@end
