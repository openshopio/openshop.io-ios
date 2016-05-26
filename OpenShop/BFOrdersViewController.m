//
//  BFOrdersViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFOrdersViewController.h"
#import "BFOrdersTableViewCellExtension.h"
#import "BFAPIManager.h"
#import "UINavigationController+BFCustomTitleView.h"
#import "BFAppPreferences.h"
#import "BFOrder.h"
#import "BFDataRequestOrderInfo.h"
#import "BFTabBarController.h"
#import "PersistentStorage.h"
#import "BFOrderDetailViewController.h"
#import "BFOrderShipping.h"

/**
 * Number of orders fetched in a single request.
 */
static NSUInteger const ordersFetchPageSize       = 8;
/**
 * Storyboard order detail segue identifier.
 */
static NSString *const orderDetailSegueIdentifier = @"orderDetailSegue";



@interface BFOrdersViewController ()

/**
 * Orders datasource.
 */
@property (nonatomic, strong) NSMutableArray *orders;
/**
 * Flag indicating whether all orders have been already fetched.
 */
@property (nonatomic, assign) BOOL didLoadAllProducts;
/**
 * Orders table view cell extension.
 */
@property (nonatomic, strong) BFOrdersTableViewCellExtension *ordersExtension;
/**
 * The orders info.
 */
@property (nonatomic, strong) BFDataRequestOrderInfo *ordersInfo;

@end


@implementation BFOrdersViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup orders info
    [self setupOrdersInfo];
    
    // empty data set customization
    [self customizeEmptyDataSet];
    
    // table view cell extensions
    [self setupExtensions];
    
    // fetch data
    [self reloadDataFromNetwork];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // title view
    [self.navigationController setCustomTitleViewText:[BFLocalizedString(kTranslationMyOrders, @"My orders") uppercaseString]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark - Orders Info

- (void)setupOrdersInfo {
    if(!self.ordersInfo) {
        self.ordersInfo = [[BFDataRequestOrderInfo alloc]initWithOffset:@0 limit:@(ordersFetchPageSize)];
    }

    if(!self.ordersInfo.offset && !self.ordersInfo.limit) {
        self.ordersInfo.offset = @0;
        self.ordersInfo.limit = @(ordersFetchPageSize);
    }
    
    _orders = [NSMutableArray new];
}


#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // orders extension
    _ordersExtension = [[BFOrdersTableViewCellExtension alloc]initWithTableViewController:self];
    _ordersExtension.orders = @[];
    
    [self setExtensions:@[_ordersExtension]];
}

- (void)cleanDataSource {
    // remove all retrieved banners
    if(_ordersExtension) {
        _ordersExtension.orders = @[];
    }
    
    [self.orders removeAllObjects];
    // scroll to top to display empty data set correctly
    [self.tableView setContentOffset:CGPointZero];
    [self.tableView reloadData];
    
    // default values
    self.loadingData = false;
    self.didLoadAllProducts = false;
    self.ordersInfo.offset = @0;
    
}


#pragma mark - Data Fetching

- (void)setDidLoadAllProducts:(BOOL)didLoadAllProducts {
    _didLoadAllProducts = didLoadAllProducts;
    if(self.ordersExtension) {
        self.ordersExtension.showsFooter = !didLoadAllProducts;
    }
}

- (void)setLoadingData:(BOOL)loadingData {
    super.loadingData = loadingData;
}


- (void)reloadDataFromNetwork {
    // data fetching in progress or all products has been already fetched
    if (self.loadingData || self.didLoadAllProducts) {
        return;
    }

    self.loadingData = YES;
    
    // fetch orders
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager]findOrdersWithInfo:self.ordersInfo completionBlock:^(NSArray *records, id customResponse, NSError *error) {
        // error results
        if(error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BFError *customError = [BFError errorWithError:error];
                [customError showAlertFromSender:weakSelf];
                weakSelf.loadingData = NO;
            });
        }
        else {
            [weakSelf.orders addObjectsFromArray:records];
            weakSelf.ordersExtension.orders = weakSelf.orders;
            
            weakSelf.ordersInfo.offset = @([weakSelf.ordersInfo.offset unsignedIntegerValue] + ordersFetchPageSize);
            weakSelf.didLoadAllProducts = records.count < ordersFetchPageSize;
         
            // reload content view
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                weakSelf.loadingData = NO;
            });
        }
    }];
    
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == [collectionView numberOfItemsInSection:indexPath.section] - 1) {
        [self reloadDataFromNetwork];
    }
}


#pragma mark - DZNEmptyDataSetSource Customization

- (void)customizeEmptyDataSet {
    self.emptyDataImage = [UIImage imageNamed:@"EmptyBannersPlaceholder"];
    self.emptyDataTitle = BFLocalizedString(kTranslationNoOrders, @"No orders");
    self.emptyDataSubtitle = BFLocalizedString(kTranslationGoShopping, @"Go shopping");
}


#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if (!self.loadingData) {
        [self.tabBarController setSelectedIndex:BFTabBarItemCategories];
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    if (!self.loadingData) {
        [self.tabBarController setSelectedIndex:BFTabBarItemCategories];
    }
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return true;
}


#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // order detail controller
    if ([[segue identifier] isEqualToString:orderDetailSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFOrderDetailViewController class]]) {
            BFOrderDetailViewController *orderDetailController = (BFOrderDetailViewController *)segue.destinationViewController;
            [self applySegueParameters:orderDetailController];
        }
    }
}


#pragma mark - BFDataExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    if(viewController == [BFOrderDetailViewController class]) {
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:orderDetailSegueIdentifier sender:self];
    }
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {
    // remove table view cell separators for empty cells
    [UITableView appearanceWhenContainedIn:self, nil].tableFooterView = [[UIView alloc] init];
    // table view background
    [[UITableView appearanceWhenContainedIn:self, nil] setBackgroundView:nil];
    [[UITableView appearanceWhenContainedIn:self, nil] setBackgroundColor:[UIColor whiteColor]];
}




@end
