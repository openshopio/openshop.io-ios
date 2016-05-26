//
//  BFSettingsViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFSettingsViewController.h"
#import "BFSettingsShopsTableViewCellExtension.h"
#import "BFAPIManager.h"
#import "BFMoreViewController.h"


@interface BFSettingsViewController ()

/**
 * Shops settings table view cell extension.
 */
@property (nonatomic, strong) BFSettingsShopsTableViewCellExtension *shopsExtension;

@end


@implementation BFSettingsViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // empty data set customization
    [self customizeEmptyDataSet];
    
    // fetch data
    [self reloadDataFromNetwork];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // title view
    self.navigationItem.title = [BFLocalizedString(kTranslationOpenShop, @"OpenShop") uppercaseString];
}

#pragma mark - Table View Cell Extensions

- (void)setupExtensions:(NSArray *)shops {
    // default values
    [self removeAllExtensions];
    
    // shops extension
    _shopsExtension = [[BFSettingsShopsTableViewCellExtension alloc]initWithTableViewController:self];
    _shopsExtension.shops = shops;
    [self addExtension:_shopsExtension];
}

- (void)cleanDataSource {
    // remove all fetched settings
    [self removeAllExtensions];
    [self.tableView reloadData];
}


#pragma mark - Data Fetching

- (void)reloadDataFromNetwork {
    // data fetching flag
    self.loadingData = true;
    // empty data source
    [self cleanDataSource];
    
    // fetch categories
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager]findShopsWithCompletionBlock:^(NSArray *records, id customResponse, NSError *error) {
        // error results
        if(error) {
            BFError *customError = [BFError errorWithError:error];
            [customError showAlertFromSender:weakSelf];
        }
        else {
            // refresh displayed data
            [weakSelf setupExtensions:records];
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


#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return true;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if (!self.loadingData) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    if (!self.loadingData) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - DZNEmptyDataSetSource Customization

- (void)customizeEmptyDataSet {
    self.emptyDataTitle = BFLocalizedString(kTranslationNoSettings, @"No settings");
    self.emptyDataSubtitle = BFLocalizedString(kTranslationGoBack, @"Go back");
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {
    
}


#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    if(viewController == [BFMoreViewController class]) {
        // return back
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end


