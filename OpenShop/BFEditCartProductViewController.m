//
//  BFEditProductInCartViewController.m
//  OpenShop
//
//  Created by Petr Škorňok on 01.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFEditCartProductViewController.h"
#import "BFEditCartProductTableViewCellExtension.h"
#import "BFButtonFooterView.h"
#import "BFAPIManager.h"
#import "BFError.h"
#import "BFAPIRequestCartProductInfo.h"
#import "BFProductVariant.h"
#import "UIWindow+BFOverlays.h"

/**
 * Delay in seconds for presenting failure overlay.
 */
static CGFloat const orderFailureDismissDelay = 2.0;
/**
 * Storyboard embed footer button segue identifier.
 */
static NSString *const embedFooterButtonSegueIdentifier = @"embedFooterButtonSegue";
/**
 * Storyboard order form segue identifier.
 */
static NSString *const paymentSegueIdentifier = @"paymentSegue";

@interface BFEditCartProductViewController ()

/**
 * Edit color and size table view cell extension.
 */
@property (nonatomic, strong) BFEditCartProductTableViewCellExtension *editCartProductItemsExtension;
/**
 * Selected product variant color.
 */
@property (nonatomic, strong) BFProductVariantColor *selectedProductColor;
/**
 * Selected product variant size.
 */
@property (nonatomic, strong) BFProductVariantSize *selectedProductSize;
/**
 * Selected quantity.
 */
@property (nonatomic, strong) NSNumber *selectedQuantity;

@end

@implementation BFEditCartProductViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup table view cell extensions
    [self setupExtensions];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // title view
    self.navigationItem.title = [BFLocalizedString(kTranslationEditProduct, @"Edit product") uppercaseString];
}

#pragma mark - Custom getters & setters

- (void)setCartProduct:(BFCartProductItem *)cartProduct {
    _cartProduct = cartProduct;
    _selectedQuantity = _cartProduct.quantity;
    _selectedProductSize = _cartProduct.productVariant.size;
    _selectedProductColor = _cartProduct.productVariant.color;
}

#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // default values
    [self removeAllExtensions];
    __weak __typeof(self)weakSelf = self;

    _editCartProductItemsExtension = [[BFEditCartProductTableViewCellExtension alloc]initWithTableViewController:self];
    // initial values
    _editCartProductItemsExtension.selectedProductColor = self.selectedProductColor;
    _editCartProductItemsExtension.selectedProductSize = self.selectedProductSize;
    _editCartProductItemsExtension.selectedQuantity = self.selectedQuantity;
    // did select value from picker callback
    _editCartProductItemsExtension.didSelectProductVariantColorBlock = ^(BFProductVariantColor *color) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.selectedProductColor = color;
        // refresh sizes based on the selected color
        [strongSelf updateProductVariants];
    };
    _editCartProductItemsExtension.didSelectProductVariantSizeBlock = ^(BFProductVariantSize *size) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.selectedProductSize = size;
    };
    _editCartProductItemsExtension.didSelectQuantityBlock = ^(NSNumber *quantity) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.selectedQuantity = quantity;
    };

    [self addExtension:_editCartProductItemsExtension];
    // refresh data source for pickers
    [self updateProductVariants];
}

#pragma mark - Update data source

- (void)updateProductVariants {
    BFProduct *product = self.cartProduct.productVariant.product;
    if (product) {
        self.editCartProductItemsExtension.productColors = [[StorageManager defaultManager]findProductVariantColorsForProducts:@[product] withSizes:nil];
        self.editCartProductItemsExtension.productSizes = [[StorageManager defaultManager]findProductVariantSizesForProducts:@[product] withColors:self.selectedProductColor ? @[self.selectedProductColor] : nil];
    }
}

#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // embed footer button controller
    if ([[segue identifier] isEqualToString:embedFooterButtonSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFButtonFooterView class]]) {
            BFButtonFooterView *footerButtonController = (BFButtonFooterView *)segue.destinationViewController;
            __weak __typeof(self)weakSelf = self;
            __weak __typeof(self.cartProduct)weakCartProduct = self.cartProduct;
            footerButtonController.actionButtonTitle = BFLocalizedString(kTranslationEdit, @"kTranslationEdit");
            footerButtonController.actionButtonBlock = ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                __strong __typeof(weakCartProduct)strongCartProduct = weakCartProduct;
                BFProductVariant *productVariant = [[StorageManager defaultManager]findProductVariantForProduct:(BFProduct *)strongSelf.cartProduct.productVariant.product withColor:self.selectedProductColor size:self.selectedProductSize];
                
                if(!productVariant && !strongCartProduct) {
                    BFError *customError = [BFError errorWithCode:BFErrorCodeWishlistNoProduct];
                    [customError showAlertFromSender:self];
                }
                else {
                    // update product in cart network request
                    [strongSelf.view.window showIndeterminateSmallProgressOverlayWithTitle:nil animated:YES];
                    
                    BFAPIRequestCartProductInfo *cartProductInfo = [[BFAPIRequestCartProductInfo alloc] initWithProductVariantIdentification:productVariant.productVariantID
                                                                                                                   cartProductIdentification:strongCartProduct.cartItemID
                                                                                                                                    quantity:strongSelf.selectedQuantity];
                    [[BFAPIManager sharedManager] updateProductVariantInCartWithInfo:cartProductInfo completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
                        __typeof__(weakSelf) strongSelf = weakSelf;
                        [strongSelf.view.window dismissAllOverlaysWithCompletion:^{
                            if (error) {
                                NSString *message = [BFError APIFailureMessageWithError:error];
                                [strongSelf.view.window showFailureOverlayWithTitle:message animated:YES];
                                [strongSelf.view.window dismissAllOverlaysWithCompletion:nil animated:YES afterDelay:orderFailureDismissDelay];
                            }
                            else {
                                // dismiss modal controller
                                [self dismissAnimated:YES];
                            }
                        } animated:YES afterDelay:1.4];
                    }];
                }
            };
            [self applySegueParameters:footerButtonController];
        }
    }
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return false;
}

#pragma mark - Custom Appearance

+ (void)customizeAppearance {
    
}

@end
