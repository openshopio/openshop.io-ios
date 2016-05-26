//
//  BFBannersViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFBannersViewController.h"
#import "BFAPIManager.h"
#import "BFBannerTableViewCellExtension.h"
#import "BFTabBarController.h"
#import "NSObject+BFStoryboardInitialization.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"
#import "UINavigationController+BFCustomTitleView.h"
#import "UIFont+BFFont.h"
#import "BFProductsViewController.h"
#import "BFProductsViewController.h"
#import "BFProductDetailViewController.h"
#import "BFPushNotificationHandler.h"
/**
 * Number of banners fetched in a single request.
 */
static NSUInteger const bannersFetchPageSize        = 20;
/**
 * Storyboard product detail segue identifier.
 */
static NSString *const productDetailSegueIdentifier = @"productDetailSegue";
/**
 * Storyboard products segue identifier.
 */
static NSString *const productsSegueIdentifier      = @"productsSegue";


@interface BFBannersViewController ()

/**
 * Banners table view cell extension.
 */
@property (nonatomic, strong) BFBannerTableViewCellExtension *bannersExtension;

@end


@implementation BFBannersViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // register for remote notifications if not in the testing environment
    [BFPushNotificationHandler tryToRegisterForRemoteNotifications];

    // empty data set customization
    [self customizeEmptyDataSet];
    
    // table view cell extensions
    [self setupExtensions];
    
    // fetch data
    [self reloadDataFromNetwork];
    
    // reload banners if the shop changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopChangedAction) name:BFLanguageDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // title view
    [self.navigationController setCustomTitleViewText:[BFLocalizedString(kTranslationJustArrived, @"Just arrived") uppercaseString]];
}

#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // banners extension
    _bannersExtension = [[BFBannerTableViewCellExtension alloc]initWithTableViewController:self];
    _bannersExtension.banners = @[];
    
    [self setExtensions:@[_bannersExtension]];
}

- (void)cleanDataSource {
    // remove all retrieved banners
    if(_bannersExtension) {
        _bannersExtension.banners = @[];
        [self.tableView reloadData];
    }
}


#pragma mark - Data Fetching

- (void)reloadDataFromNetwork {
    // empty data source
    [self cleanDataSource];

    // data fetching flag
    self.loadingData = true;
    
    // fetch banners
    __weak __typeof__(self) weakSelf = self;
    // pager info
    BFDataRequestPagerInfo *pagerInfo = [[BFDataRequestPagerInfo alloc]initWithOffset:@0 limit:@(bannersFetchPageSize)];
    [[BFAPIManager sharedManager]findBannersWithInfo:pagerInfo completionBlock:^(NSArray *records, id customResponse, NSError * error) {
        // error results
        if(error) {
            BFError *customError = [BFError errorWithError:error];
            [customError showAlertFromSender:weakSelf];
        }
        else {
            weakSelf.bannersExtension.banners = records;
        }
        // data fetching flag
        weakSelf.loadingData = false;
    }];
}

- (void)setLoadingData:(BOOL)loadingData {
    super.loadingData = loadingData;

    if (!loadingData) {
        [self.tableView reloadData];
    }
}

#pragma mark - Language changed notification

- (void)shopChangedAction {
    [self.navigationController popToRootViewControllerAnimated:NO];
    // fetch data
    [self reloadDataFromNetwork];
}

#pragma mark - DZNEmptyDataSetSource Customization

- (void)customizeEmptyDataSet {
    self.emptyDataImage = [UIImage imageNamed:@"EmptyBannersPlaceholder"];
    self.emptyDataTitle = BFLocalizedString(kTranslationNoOffersHeadline, @"No offers");
    self.emptyDataSubtitle = BFLocalizedString(kTranslationGoToCategories, @"Go to product categories");
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
    // product detail controller
    if ([[segue identifier] isEqualToString:productDetailSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFProductDetailViewController class]]) {
            BFProductDetailViewController *productDetailController = (BFProductDetailViewController *)segue.destinationViewController;
            [self applySegueParameters:productDetailController];
        }
    }
    // products controller
    else if ([[segue identifier] isEqualToString:productsSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFProductsViewController class]]) {
            BFProductsViewController *productsController = (BFProductsViewController *)segue.destinationViewController;
            [self applySegueParameters:productsController];
        }
    }
}

- (IBAction)unwindToOffersViewController:(UIStoryboardSegue *)unwindSegue {
    
}

#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    // products controller
    if(viewController == [BFProductsViewController class]) {
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:productsSegueIdentifier sender:self];
    }
    // product detail controller
    else if(viewController == [BFProductDetailViewController class]) {
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:productDetailSegueIdentifier sender:self];
    }
}

#pragma mark - Custom Appearance

+ (void)customizeAppearance {
    // no separator
    [UITableView appearanceWhenContainedIn:self, nil].separatorColor = [UIColor clearColor];
    // remove table view cell separators for empty cells
    [UITableView appearanceWhenContainedIn:self, nil].tableFooterView = [[UIView alloc] init];
}


@end
