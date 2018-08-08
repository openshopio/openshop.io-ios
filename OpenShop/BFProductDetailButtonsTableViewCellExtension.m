//
//  BFProductDetailButtonsTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductDetailButtonsTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewController.h"
#import "UIColor+BFColor.h"
#import "BFAlignedImageButton.h"
#import "BFActionSheetPicker.h"
#import "NSArray+BFObjectFiltering.h"
#import "BFProductVariantSize+BFNSelection.h"
#import "BFProductVariantColor+BFNSelection.h"
#import "BFAPIManager.h"
#import "BFAPIRequestCartProductInfo.h"
#import "BFProductVariant.h"
#import "BFCheckoutTooltipViewController.h"
#import "NSObject+BFStoryboardInitialization.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "User.h"
#import "BFTabBarController.h"
#import "BFShareImageProvider.h"
#import "BFShareTextProvider.h"
#import "UIWindow+BFOverlays.h"

/**
 * Product detail action buttons type.
 */
typedef NS_ENUM(NSInteger, BFProductDetailButtonType) {
    BFProductDetailButtonSelectColor = 0,
    BFProductDetailButtonSelectSize,
    BFProductDetailButtonAddToCart,
    BFProductDetailButtonShareWithFriends,
};


/**
 * Product detail action button left aligned image table view cell reuse identifier.
 */
static NSString *const productDetailButtonLeftAlignedCellReuseIdentifier  = @"BFProductDetailButtonLeftAlignedTableViewCellIdentifier";
/**
 * Product detail action button right aligned image table view cell reuse identifier.
 */
static NSString *const productDetailButtonRightAlignedCellReuseIdentifier = @"BFProductDetailButtonRightAlignedTableViewCellIdentifier";
/**
 * Product detail action button table view cell reuse identifier.
 */
static CGFloat const productDetailButtonEmptyHeaderFooterViewHeight       = 2.0;
/**
 * Product detail action button table view cell height.
 */
static CGFloat const productDetailButtonCellHeight                        = 60.0;
/**
 * Success overlay informing when product was added to cart dismiss delay.
 */
static CGFloat const productAddedToCartSuccessDismissDelay                = 1.0;
/**
 * Failure overlay informing when product was not added to cart dismiss delay.
 */
static CGFloat const productAddedToCartFailureDismissDelay                = 2.0;
/**
 * Product checkout tooltip scroll animation duration.
 */
static CGFloat const productCheckoutTooltipAnimationDuration              = 0.3;
/**
 * Product checkout tooltip scroll bottom margin.
 */
static CGFloat const productCheckoutTooltipScrollBottomMargin             = 100.0;
/**
 * After user login delay to display overlay informing when product is being added to cart.
 */
static CGFloat const productAddToCartAfterLoginDelay                      = 1.0;
/**
 * Product detail action button item popover bottom margin.
 */
static CGFloat const activityItemProviderPopoverSourceRectBottom          = 10.0;
/**
 * Product detail action button border width.
 */
static CGFloat const buttonBorderWidth                                    = 1.0;



@interface BFProductDetailButtonsTableViewCellExtension ()

/**
 * Product detail action buttons.
 */
@property (nonatomic, strong) NSMutableArray *buttons;

@end


@implementation BFProductDetailButtonsTableViewCellExtension

@dynamic tableViewController;

#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super initWithTableViewController:tableViewController];
    if (self) {
        self.buttons = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)didLoad {
    [self refreshDataSource];
}


#pragma mark - Datasource update

- (void)setFinishedLoading:(BOOL)finishedLoading {
    _finishedLoading = finishedLoading;
    [self refreshDataSource];
}

- (void)refreshDataSource {
    [self.buttons removeAllObjects];
    if(_finishedLoading) {
        // color selection button
        if(self.productColors.count > 1) {
            [self.buttons addObject:@(BFProductDetailButtonSelectColor)];
        }
        // size selection button
        if(self.productSizes.count >= 1) {
            [self.buttons addObject:@(BFProductDetailButtonSelectSize)];
        }
        // add to cart
        [self.buttons addObject:@(BFProductDetailButtonAddToCart)];
        // share with friends
        [self.buttons addObject:@(BFProductDetailButtonShareWithFriends)];
    }
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.buttons count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return productDetailButtonCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFProductDetailButtonType buttonType = (BFProductDetailButtonType)[[self.buttons objectAtIndex:index]integerValue];
    
    NSString *buttonCellIdentifier = productDetailButtonLeftAlignedCellReuseIdentifier;
    if(buttonType == BFProductDetailButtonSelectColor || buttonType == BFProductDetailButtonSelectSize) {
        buttonCellIdentifier = productDetailButtonRightAlignedCellReuseIdentifier;
    }
    
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:buttonCellIdentifier];
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:buttonCellIdentifier];
    }

    // cell configuration for action button type
    [self configureButtonCell:cell forType:buttonType];
    
    return cell;
}

- (void)configureButtonCell:(BFTableViewCell *)cell forType:(BFProductDetailButtonType)buttonType {
    BFAlignedImageButton *button = (BFAlignedImageButton *)cell.actionButton;
    
    if(buttonType == BFProductDetailButtonSelectColor || buttonType == BFProductDetailButtonSelectSize) {
        NSString *buttonTitle;
        // select size
        if(buttonType == BFProductDetailButtonSelectSize) {
            buttonTitle = self.selectedProductSize ? [self.selectedProductSize.value uppercaseString] : [BFLocalizedString(kTranslationSize, @"Size")uppercaseString];
            [cell.actionButton addTarget:self action:@selector(selectSizeClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            // disable button if only one size is present
            if(self.productSizes.count == 1) {
                [button setTitleColor:[UIColor grayColor]  forState:UIControlStateNormal];
                button.enabled = NO;
                button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            }
            else {
                [button setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
                button.enabled = YES;
                button.layer.borderColor = [UIColor blackColor].CGColor;
            }
        }
        // select color
        else {
            buttonTitle = self.selectedProductColor ? [self.selectedProductColor.name uppercaseString] : [BFLocalizedString(kTranslationColor, @"Color")uppercaseString];
            [cell.actionButton addTarget:self action:@selector(selectColorClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.borderColor = [UIColor blackColor].CGColor;
        }
        button.layer.borderWidth = buttonBorderWidth;
        [button setTitle:buttonTitle forState:UIControlStateNormal];
    }
    else if(buttonType == BFProductDetailButtonAddToCart || buttonType == BFProductDetailButtonShareWithFriends) {
        NSString *buttonTitle;
        UIImage *image;
        // share with friends
        if(buttonType == BFProductDetailButtonShareWithFriends) {
            [cell.actionButton addTarget:self action:@selector(shareWithFriendsClicked:) forControlEvents:UIControlEventTouchUpInside];
            buttonTitle = [BFLocalizedString(kTranslationShareWithFriends, @"Share with friends") uppercaseString];
            image = [UIImage imageNamed:@"FacebookIcon"];
            button.backgroundColor = [UIColor BFN_FBBlueColorWithAlpha:1.0];
        }
        // add to cart
        else {
            [cell.actionButton addTarget:self action:@selector(addToCartClicked:) forControlEvents:UIControlEventTouchUpInside];
            buttonTitle = [BFLocalizedString(kTranslationAddToCart, @"Add to the cart") uppercaseString];
            image = [UIImage imageNamed:@"TabBarCartUnselected"];
            button.backgroundColor = [UIColor BFN_pinkColor];
            button.accessibilityLabel = @"ADDTOCART";
        }
        
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateNormal];
    }
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}


#pragma mark - Product Color Selection

- (IBAction)selectColorClicked:(id)sender {
    // initial selection index
    NSUInteger initialSelection = 0;
    if(self.selectedProductColor && [self.productColors indexOfObject:self.selectedProductColor] != NSNotFound) {
        initialSelection = [self.productColors indexOfObject:self.selectedProductColor];
    }
    
    // selection completion block
    __weak UIButton *weakSender = (UIButton *)sender;
    __weak __typeof(self)weakSelf = self;
    BFNActionDoneBlock doneBlock = ^(BFActionSheetPicker *picker, NSInteger selectedIndex, id<BFNSelection> selectedValue) {
        if(selectedValue && [selectedValue isKindOfClass:[BFProductVariantColor class]]) {
            weakSelf.selectedProductColor = (BFProductVariantColor *)selectedValue;
            [weakSender setTitle:weakSelf.selectedProductColor.name forState:UIControlStateNormal];
            
            // table view controller interaction
            if ([self.tableViewController respondsToSelector:@selector(selectedProductVariantColor:)]) {
                [self.tableViewController selectedProductVariantColor:selectedValue];
            }
        }
    };
    
    // present selection picker
    [BFActionSheetPicker showPickerWithTitle:BFLocalizedString(kTranslationChooseColor, @"Pick a color")
                         rows:self.productColors
             initialSelection:initialSelection
                    doneBlock:doneBlock
                  cancelBlock:nil
                       origin:sender];
}


#pragma mark - Product Size Selection

- (IBAction)selectSizeClicked:(id)sender {
    // initial selection index
    NSUInteger initialSelection = 0;
    if(self.selectedProductSize && [self.productSizes indexOfObject:self.selectedProductSize] != NSNotFound) {
        initialSelection = [self.productSizes indexOfObject:self.selectedProductSize];
    }
    
    // selection completion block
    __weak UIButton *weakSender = (UIButton *)sender;
    __weak __typeof(self)weakSelf = self;
    BFNActionDoneBlock doneBlock = ^(BFActionSheetPicker *picker, NSInteger selectedIndex, id<BFNSelection> selectedValue) {
        if(selectedValue && [selectedValue isKindOfClass:[BFProductVariantSize class]]) {
            weakSelf.selectedProductSize = (BFProductVariantSize *)selectedValue;
            [weakSender setTitle:weakSelf.selectedProductSize.value forState:UIControlStateNormal];
        }
    };
    
    // present selection picker
    [BFActionSheetPicker showPickerWithTitle:BFLocalizedString(kTranslationChooseSize, @"Pick a size")
                         rows:self.productSizes
             initialSelection:initialSelection
                    doneBlock:doneBlock
                  cancelBlock:nil
                       origin:sender];
}


#pragma mark - Product Add to Cart

- (IBAction)addToCartClicked:(id)sender {
    BFProductVariant *productVariant = [[StorageManager defaultManager]findProductVariantForProduct:(BFProduct *)self.product withColor:self.selectedProductColor size:self.selectedProductSize];
    
    // verify product variant existence
    if(!productVariant) {
        BFError *customError = [BFError errorWithCode:BFErrorCodeCartNoProduct];
        [customError showAlertFromSender:self.tableViewController];
    }
    else {
        // add product variant to cart
        if([User isLoggedIn]) {
            [self addProductVariantToCart:productVariant];
        }
        // request user login
        else {
            BFTabBarController *tabBarController = (BFTabBarController *)self.tableViewController.tabBarController;
            if(tabBarController) {
                __weak __typeof__(tabBarController) weakTabBarController = tabBarController;
                __weak __typeof__(self) weakSelf = self;
                tabBarController.completionBlock = ^(BOOL skipped) {
                    [weakTabBarController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
                    [weakSelf performSelector:@selector(addProductVariantToCart:) withObject:productVariant afterDelay:productAddToCartAfterLoginDelay];
                };
                tabBarController.didAppearBlock = ^(BFOnboardingViewController *controller) {
                    [controller.view.window showToastWarningMessage:BFLocalizedString(kTranslationLoginToAddToCart, @"Please login to add the product to the cart") withCompletion:nil];
                };
                // present the onboarding view from the tab bar controller
                [self.tableViewController performSegueWithViewController:[BFOnboardingViewController class] params:nil];
            }
        }
    }
}


- (void)addProductVariantToCart:(BFProductVariant *)productVariant {
    [self.tableViewController.view.window showIndeterminateSmallProgressOverlayWithTitle:BFLocalizedString(kTranslationAddingToCart, @"Adding to the cart") animated:YES];
    
    __weak __typeof__(self.tableViewController) weakController = self.tableViewController;
    __weak __typeof__(self) weakSelf = self;
    // cart item
    BFAPIRequestCartProductInfo *cartInfo = [[BFAPIRequestCartProductInfo alloc]initWithProductVariantIdentification:productVariant.productVariantID
                                                                                                            quantity:@1];
    // save cart item
    [[BFAPIManager sharedManager]addProductVariantToCartWithInfo:cartInfo completionBlock:^(id response, NSError *error) {
        [weakController.view.window dismissAllOverlaysWithCompletion:^{
            __typeof__(weakController) strongController = weakController;
            if(error) {
                [strongController.view.window showFailureOverlayWithTitle:BFLocalizedString(kTranslationProductIsUnavailable, @"Product is unavailable") animated:YES];
                [strongController.view.window dismissAllOverlaysWithCompletion:nil animated:YES afterDelay:productAddedToCartFailureDismissDelay];
            }
            else {
                [strongController.view.window showSuccessOverlayWithTitle:BFLocalizedString(kTranslationAddedToCart, @"Added to the cart") animated:YES];
                [strongController.view.window dismissAllOverlaysWithCompletion:^{
                    // update shopping cart badge value
                    [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFCartDidChangeNotification];
                    // present checkout tooltip on success
                    __typeof__(weakSelf) strongSelf = weakSelf;
                    [strongSelf presentCheckoutTooltipView];
                } animated:YES afterDelay:productAddedToCartSuccessDismissDelay];
            }
        } animated:YES];
    }];
}

- (void)presentCheckoutTooltipView {
    // checkout tooltip view controller instance
    BFCheckoutTooltipViewController *tooltipViewController = (BFCheckoutTooltipViewController *)[self BFN_mainStoryboardClassInstanceWithClass:[BFCheckoutTooltipViewController class]];
    
    __weak __typeof__(self.tableView) weakTableView = self.tableView;
    __weak __typeof__(self.tableViewController) weakTableViewController = self.tableViewController;
    __weak __typeof__(self) weakSelf = self;
    
    // define tooltip tapped callback
    tooltipViewController.tooltipTappedHandler = ^{
        __typeof__(weakTableViewController) strongTableViewController = weakTableViewController;
        if(strongTableViewController.tabBarController) {
            [((BFTabBarController *)strongTableViewController.tabBarController) setSelectedItem:BFTabBarItemShoppingCart withPopToRootViewController:true];
        }
    };
    // present form sheet
    [tooltipViewController presentFormSheetWithSize:self.tableViewController.view.frame.size optionsHandler:^(MZFormSheetPresentationViewController *formSheetController) {
        // form sheet styles
        [[MZFormSheetPresentationController appearance] setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.3f]];
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
        formSheetController.shadowRadius = 0.5;
        
        // custom presentation handlers
        formSheetController.presentationController.dismissalTransitionWillBeginCompletionHandler = ^(UIViewController *presentedFSViewController) {
            __typeof__(weakTableView) strongTableView = weakTableView;
            [UIView animateWithDuration:productCheckoutTooltipAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                strongTableView.contentInset = UIEdgeInsetsZero;
                strongTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
            } completion:nil];
        };
        formSheetController.presentationController.presentationTransitionWillBeginCompletionHandler = ^(UIViewController *presentedFSViewController) {
            __typeof__(weakTableView) strongTableView = weakTableView;
            __typeof__(weakSelf) strongSelf = weakSelf;
            
            // scroll to the table view bottom when presented
            CGFloat calculatedHeight = [strongSelf calculateContentHeight:strongTableView];
            if (calculatedHeight > strongTableView.frame.size.height) {
                CGPoint offset = CGPointMake(0, calculatedHeight - strongTableView.frame.size.height + productCheckoutTooltipScrollBottomMargin);
                [strongTableView setContentOffset:offset animated:YES];
                
                strongTableView.contentInset = UIEdgeInsetsMake(0, 0, productCheckoutTooltipScrollBottomMargin, 0);
                strongTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, productCheckoutTooltipScrollBottomMargin, 0);
            }
        };
    } animated:YES fromSender:self.tableViewController];
}

- (CGFloat)calculateContentHeight:(UITableView *)tableView {
    // table view content height calculation
    if(tableView.delegate) {
        CGFloat contentHeight = 0;
        for(int i = 0; i < tableView.numberOfSections; i++) {
            // rows height
            for(int j = 0; j < [tableView numberOfRowsInSection:i]; j++) {
                contentHeight += [tableView.delegate tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            }
            // section header / footer height
            contentHeight += [tableView.delegate tableView:tableView heightForFooterInSection:i];
            contentHeight += [tableView.delegate tableView:tableView heightForHeaderInSection:i];
        }
        // table view header / footer view height
        return contentHeight + tableView.tableHeaderView.frame.size.height + tableView.tableFooterView.frame.size.height;
    }
    // return inaccurate content size if no delegate is assigned
    return tableView.contentSize.height;
}


#pragma mark - Product Share With Friends

- (IBAction)shareWithFriendsClicked:(id)sender {
    BFProductVariant *productVariant = [[StorageManager defaultManager]findProductVariantForProduct:(BFProduct *)self.product withColor:self.selectedProductColor size:self.selectedProductSize];
    
    // verify product variant existence
    if(!productVariant) {
        BFError *customError = [BFError errorWithCode:BFErrorCodeWishlistNoProduct];
        [customError showAlertFromSender:self.tableViewController];
    }
    else {
        // formatted items to share
        NSMutableArray *itemsToShare = [[NSMutableArray alloc]initWithObjects:self.tableViewController, nil];
        // text to share
        BFShareTextProvider *textProvider = [[BFShareTextProvider alloc] initWithPlaceholderText:BFLocalizedString(kTranslationSharePlaceholder, @"I want this from OpenShop:")
                                                                                        facebook:BFLocalizedString(kTranslationShareFacebook, @"I want this from @OpenShop:")
                                                                                         twitter:BFLocalizedString(kTranslationShareTwitter, @"I want this from @openshop.io:")];
        
        [itemsToShare addObject:textProvider];

        // URL to share
        if(self.product.productURL) {
            [itemsToShare addObject:(NSURL *)[NSURL URLWithString:(NSString *)productVariant.product.productURL]];
        }
        
        // image to share
        if(self.product.imageURL) {
            [self.tableViewController.view.window showIndeterminateSmallProgressOverlayWithTitle:nil animated:YES];
            
            __weak __typeof__(self) weakSelf = self;
            __weak __typeof__(self.tableViewController) weakController = self.tableViewController;

            NSURL *URL = [NSURL URLWithString:(NSString *)self.product.imageURL];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFImageResponseSerializer serializer];
            [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                __typeof__(weakSelf) strongSelf = weakSelf;
                [weakController.view.window dismissAllOverlaysWithCompletion:^{
                    BFShareImageProvider *imageProvider = [[BFShareImageProvider alloc] initWithImage:responseObject];
                    [itemsToShare addObject:imageProvider];
                    // present activity view controller
                    [strongSelf presentActivityViewControllerWithItems:itemsToShare fromSender:sender];
                } animated:YES];
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                [weakController.view.window dismissAllOverlaysWithCompletion:^{
                    __typeof__(weakSelf) strongSelf = weakSelf;
                    // present activity view controller
                    [strongSelf presentActivityViewControllerWithItems:itemsToShare fromSender:sender];
                } animated:YES];
            }];
        }
        else {
            // present activity view controller
            [self presentActivityViewControllerWithItems:itemsToShare fromSender:sender];
        }
    }
}

- (void)presentActivityViewControllerWithItems:(NSArray *)items fromSender:(id)sender {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    // adjust popover source rect
    if([activityVC respondsToSelector:@selector(popoverPresentationController)]) {
        UIButton *button = (UIButton *)sender;
        activityVC.popoverPresentationController.sourceView = button;
        activityVC.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMaxX(button.frame)/2.0f, button.bounds.origin.y+activityItemProviderPopoverSourceRectBottom, 0, 0);
        activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
    }
    
    [self.tableViewController presentViewController:activityVC animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate

- (CGFloat)getHeaderHeight {
    // to prevent grouped table view return the default value
    return productDetailButtonEmptyHeaderFooterViewHeight;
}



@end
