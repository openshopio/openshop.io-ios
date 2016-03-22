//
//  BFOrderDetailViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOrderDetailViewController.h"
#import "BFOrderDetailsTableViewCellExtension.h"
#import "BFOrderItemsTableViewCellExtension.h"
#import "BFAPIManager.h"
#import "NSObject+BFStoryboardInitialization.h"
#import "User.h"
#import "BFError.h"
#import "UIWindow+BFOverlays.h"
#import "BFOrdersViewController.h"
#import "BFProductDetailViewController.h"
#import "BFProductVariant.h"

/**
 * Storyboard product detail segue identifier.
 */
static NSString *const productDetailSegueIdentifier = @"productDetailSegue";


@interface BFOrderDetailViewController ()

/**
 * Order details table view cell extension.
 */
@property (nonatomic, strong) BFOrderDetailsTableViewCellExtension *orderDetailsExtension;
/**
 * Order items (products) table view cell extension.
 */
@property (nonatomic, strong) BFOrderItemsTableViewCellExtension *orderItemsExtension;

@end


@implementation BFOrderDetailViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // title view
    self.navigationItem.title = [BFLocalizedString(kTranslationOrderDetail, @"Order detail") uppercaseString];
    
    // setup table view cell extension
    [self setupExtensions];
    
    // fetch data
    [self reloadDataFromNetwork];
}


#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // order details
    _orderDetailsExtension = [[BFOrderDetailsTableViewCellExtension alloc]initWithTableViewController:self];
    _orderDetailsExtension.finishedLoading = false;
    // order items
    _orderItemsExtension = [[BFOrderItemsTableViewCellExtension alloc]initWithTableViewController:self];
    [self setExtensions:@[_orderDetailsExtension, _orderItemsExtension]];
}

- (void)updateExtensions:(BOOL)finishedLoading animated:(BOOL)animated {
    if(self.order) {
        _orderDetailsExtension.finishedLoading = finishedLoading;
        _orderDetailsExtension.order = self.order;
        if(self.order.orderItems) {
            // sort order items
            _orderItemsExtension.orderItems = (NSArray *)[self.order.orderItems.allObjects sortedArrayUsingComparator:^NSComparisonResult(BFOrderItem *itemA, BFOrderItem *itemB) {
                if(itemA.productVariant && itemA.productVariant.product && itemA.productVariant.product.name) {
                    if(itemB.productVariant && itemB.productVariant.product && itemB.productVariant.product.name) {
                        return [itemA.productVariant.product.name compare:(NSString *)itemB.productVariant.product.name];
                    }
                    return NSOrderedDescending;
                }
                return NSOrderedAscending;
            }];
        }
    }
    
    if (animated) {
        [self reloadExtensions:@[_orderDetailsExtension, _orderItemsExtension] withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        [self.tableView reloadData];
    }
}


#pragma mark - Data Fetching

- (void)reloadDataFromNetwork {
    // data fetching flag
    self.loadingData = true;
    // order info
    BFDataRequestOrderInfo *orderInfo = [[BFDataRequestOrderInfo alloc]init];
    orderInfo.orderID = self.order.orderID;
    
    if (!orderInfo.orderID) {
        DDLogError(@"Missing orderID, cannot proceed in the network request.");
        // data fetching flag
        self.loadingData = false;
        return;
    }

    // fetch order details
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager]findOrderDetailsWithInfo:orderInfo completionBlock:^(NSArray *records, id customResponse, NSError *error) {
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
            // save order
            strongSelf.order = (BFOrder *)[records firstObject];
            // update extensions
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf updateExtensions:true animated:true];
            });
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
    return true;
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {

}


#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    if(viewController == [BFProductDetailViewController class]) {
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:productDetailSegueIdentifier sender:self];
    }
}


#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // product detail controller
    if ([[segue identifier] isEqualToString:productDetailSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFProductDetailViewController class]]) {
            BFProductDetailViewController *productDetailController = (BFProductDetailViewController *)segue.destinationViewController;
            [self applySegueParameters:productDetailController];
        }
    }
}



@end
