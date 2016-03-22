//
//  BFShippingViewController.m
//  OpenShop
//
//  Created by Petr Škorňok on 23.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFShippingViewController.h"
#import "BFOrderFormViewController.h"
#import "BFBranchViewController.h"
#import "BFShippingTableViewCellExtension.h"
#import "BFPersonalPickupTableViewCellExtension.h"
#import "StorageManager.h"
#import "BFDeliveryInfo.h"
#import "BFCartDelivery.h"
#import "BFCartPayment.h"
#import "BFBranch.h"
#import "BFButtonFooterView.h"
#import "BFPaymentViewController.h"
#import "UIWindow+BFOverlays.h"
#import "NSObject+BFStoryboardInitialization.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"
#import "ShoppingCart.h"

/**
 * Storyboard embed footer button segue identifier.
 */
static NSString *const embedFooterButtonSegueIdentifier            = @"embedFooterButtonSegue";
/**
 * Storyboard order form segue identifier.
 */
static NSString *const paymentSegueIdentifier                      = @"paymentSegue";
/**
 * Presenting segue initial branch parameter.
 */
static NSString *const segueParameterInitialBranch                 = @"initialBranch";

@interface BFShippingViewController ()

/**
 * Shipping items table view cell extension.
 */
@property (nonatomic, strong) BFShippingTableViewCellExtension *shippingItemsExtension;
/**
 * Personal pickup items table view cell extension.
 */
@property (nonatomic, strong) BFPersonalPickupTableViewCellExtension *personalPickupItemsExtension;
/**
 * Personal pickup items.
 */
@property (nonatomic, strong) NSArray<BFCartDelivery*> *personalPickupArray;
/**
 * Shipping items.
 */
@property (nonatomic, strong) NSArray<BFCartDelivery*> *shippingArray;
/**
 * Footer button.
 */
@property (nonatomic, strong) BFButtonFooterView *footerButtonView;

@end

@implementation BFShippingViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // title view
    self.navigationItem.title = [BFLocalizedString(kTranslationShipping, @"Shipping") uppercaseString];
    
    // setup table view cell extensions
    [self setupExtensions];
    
    // cart change listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartDidChange) name:BFCartDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshFooterButton];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // inform delegate about selected delivery
    BFCartDelivery *delivery = [[ShoppingCart sharedCart] selectedDelivery];
    if(delivery && [self.delegate respondsToSelector:@selector(shippingViewController:selectedShipping:)]) {
        // report selection changes
        [self.delegate shippingViewController:self selectedShipping:delivery];
    }
}

#pragma mark - Lazy properties

- (NSArray<BFCartDelivery *> *)shippingArray {
    if (!_shippingArray) {
        _shippingArray = [self.deliveryInfo.shippingArray allObjects];
    }
    return _shippingArray;
}

- (NSArray<BFCartDelivery *> *)personalPickupArray {
    if (!_personalPickupArray) {
        _personalPickupArray = [self.deliveryInfo.personalPickupArray allObjects];
    }
    return _personalPickupArray;
}

#pragma mark - Update Footer Button

- (void)refreshFooterButton {
    BFCartDelivery *delivery = [[ShoppingCart sharedCart] selectedDelivery];
    self.footerButtonView.canPerformAction = delivery != nil;
}

#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // default values
    [self removeAllExtensions];
    
    // shipping items
    _shippingItemsExtension = [[BFShippingTableViewCellExtension alloc]initWithTableViewController:self];
    _shippingItemsExtension.shippingItems = self.shippingArray;
    _shippingItemsExtension.didSelectDeliveryBlock = ^(BFCartDelivery *delivery) {
        [[ShoppingCart sharedCart] setSelectedDelivery:delivery];
        [[ShoppingCart sharedCart] setSelectedPayment:nil];
    };
    [self addExtension:_shippingItemsExtension];
    
    // personal pickup items
    _personalPickupItemsExtension = [[BFPersonalPickupTableViewCellExtension alloc]initWithTableViewController:self];
    _personalPickupItemsExtension.personalPickupItems = self.personalPickupArray;
    _personalPickupItemsExtension.didSelectDeliveryBlock = ^(BFCartDelivery *delivery) {
        [[ShoppingCart sharedCart] setSelectedDelivery:delivery];
        [[ShoppingCart sharedCart] setSelectedPayment:nil];
    };
    [self addExtension:_personalPickupItemsExtension];
}

#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    // present order form
    if(viewController == [BFPaymentViewController class]) {
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:paymentSegueIdentifier sender:self];
    }
    else if(viewController == [BFBranchViewController class]) {
        BFBranch *initialBranch = [dictionary objectForKey:segueParameterInitialBranch];
        // present branches view controller
        [self presentBranchesViewControllerWithInitialBranch:initialBranch];
    }
}

#pragma mark - Cart Did Change Listener Action

// pop to root
- (void)cartDidChange {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // embed footer button controller
    if ([[segue identifier] isEqualToString:embedFooterButtonSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFButtonFooterView class]]) {
            BFButtonFooterView *footerButtonController = (BFButtonFooterView *)segue.destinationViewController;
            footerButtonController.canPerformAction = NO;
            footerButtonController.actionButtonTitle = BFLocalizedString(kTranslationPaymentMethod, @"Payment method");
            __weak __typeof(self)weakSelf = self;
            footerButtonController.actionButtonBlock = ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf performSegueWithViewController:[BFPaymentViewController class] params:nil];
            };
            footerButtonController.disabledActionButtonBlock = ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.view.window showToastWarningMessage:BFLocalizedString(kTranslationPleaseFillInShipping, @"Please fill in shipping")
                                                 withCompletion:nil];
            };
            self.footerButtonView = footerButtonController;
            [self applySegueParameters:footerButtonController];
        }
    }
    // payment controller
    if ([[segue identifier] isEqualToString:paymentSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFPaymentViewController class]]) {
            BFPaymentViewController *paymentController = (BFPaymentViewController *)segue.destinationViewController;
            paymentController.delegate = self.orderFormController;
            [self applySegueParameters:paymentController];
        }
    }
}

- (void)presentBranchesViewControllerWithInitialBranch:(BFBranch *)initialBranch {
    // iterate over all the personal pickup items and create
    // branches array which will be presented
    NSMutableArray *branches = [[NSMutableArray alloc] init];
    for (BFCartDelivery *delivery in self.personalPickupArray) {
        BFBranch *branch = delivery.branch;
        [branches addObject:branch];
    }
    // set initial index
    NSInteger initialIndex = [branches indexOfObject:initialBranch];
    
    if (!initialBranch || initialIndex == NSNotFound) {
        DDLogError(@"Invalid branch");
        return;
    }
    
    // instantiate branch controller
    BFBranchViewController *branchController = (BFBranchViewController *)[self BFN_mainStoryboardClassInstanceWithClass:[BFBranchViewController class]];
    branchController.branches = branches;
    branchController.currentIndex = initialIndex;
    branchController.showsSelectionButton = YES;
    __weak __typeof(self)weakSelf = self;
    branchController.selectionHandler = ^(BFBranch *selectedBranch) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.personalPickupItemsExtension didSelectBranch:selectedBranch];
    };
    // present form sheet
    [branchController presentFormSheetWithOptionsHandler:nil animated:YES fromSender:self];
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return false;
}

@end
