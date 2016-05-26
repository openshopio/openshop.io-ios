//
//  BFSortViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFSortViewController.h"
#import "BFSortTableViewCellExtension.h"
#import "BFProductsViewController.h"


@interface BFSortViewController ()

/**
 * Sorting options table view cell extension.
 */
@property (nonatomic, strong) BFSortTableViewCellExtension *sortExtension;

@end


@implementation BFSortViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // extensions setup
    [self setupExtensions];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // title view
    self.navigationItem.title = [BFLocalizedString(kTranslationSort, @"Sort") uppercaseString];
}

#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // default values
    [self removeAllExtensions];
    
    // shops extension
    _sortExtension = [[BFSortTableViewCellExtension alloc]initWithTableViewController:self];
    [self addExtension:_sortExtension];
    
    // reload empty data set
    [self.tableView reloadEmptyDataSet];
}


#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    if(viewController == [BFProductsViewController class]) {
        // return back
        [self dismissAnimated:YES];
    }
}


@end


