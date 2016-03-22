//
//  BFBaseTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFBaseTableViewCellExtension.h"


@interface BFBaseTableViewCellExtension ()



@end


@implementation BFBaseTableViewCellExtension


#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super init];
    if (self) {
        self.tableViewController = tableViewController;
        self.tableView = (UITableView *)tableViewController.tableView;
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        self.tableView = tableView;
    }
    return self;
}

- (void)didLoad {
    // stub implementation (intended to be implemented in the subclass)
}

#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    // stub implementation (intended to be implemented in the subclass)
    return 0;
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    // stub implementation (intended to be implemented in the subclass)
    return 0;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    // stub implementation (intended to be implemented in the subclass)
    return nil;
}


@end
