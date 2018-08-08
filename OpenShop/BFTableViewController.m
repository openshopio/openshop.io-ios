//
//  BFTableViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFTableViewController.h"
#import "UIFont+BFFont.h"
#import "UIColor+BFColor.h"
#import "BFTableViewCellExtension.h"

@interface BFTableViewController ()


@end


@implementation BFTableViewController


#pragma mark - Initialization & Cleanup

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    self.tableView.emptyDataSetSource = nil;
    self.tableView.emptyDataSetDelegate = nil;
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // empty data source and data set delegates
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    // table view data source and delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // not loading data
    self.loadingData = false;
}


#pragma mark - BFTableViewCellExtensionDelegate

- (void)deselectRowAtIndex:(NSInteger)index onExtension:(id)extension {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:[self indexOfExtension:extension]];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)reloadExtensions:(NSArray<id<BFTableViewCellExtension>> *)extensions  withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self.tableView beginUpdates];
    // reload each extension with animation
    for (id<BFTableViewCellExtension> extension in extensions) {
        NSUInteger extensionIndex = [self indexOfExtension:extension];
        if(extensionIndex != NSNotFound) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:extensionIndex] withRowAnimation:rowAnimation];
        }
    }
    [self.tableView endUpdates];
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {

}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numOfExtensions];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self numOfExtensions] > section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:section];
        return [extension getNumberOfRows];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self numOfExtensions] > indexPath.section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:indexPath.section];
        return [extension getCellForRowAtIndex:indexPath.row];
    }
    return nil;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self numOfExtensions] > indexPath.section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:indexPath.section];
        return [extension getHeightForRowAtIndex:indexPath.row];
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if([self numOfExtensions] > indexPath.section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:indexPath.section];
        if([extension respondsToSelector:@selector(getEstimatedHeightForRowAtIndex:)]) {
            [extension getEstimatedHeightForRowAtIndex:indexPath.row];
        }
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self numOfExtensions] > indexPath.section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:indexPath.section];
        if([extension respondsToSelector:@selector(willDisplayCell:atIndex:)]) {
            [extension willDisplayCell:(UITableViewCell *)cell atIndex:indexPath.row];
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self numOfExtensions] > indexPath.section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:indexPath.section];
        if([extension respondsToSelector:@selector(willSelectRowAtIndex:)]) {
            [extension willSelectRowAtIndex:indexPath.row];
        }
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self numOfExtensions] > indexPath.section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:indexPath.section];
        if([extension respondsToSelector:@selector(didSelectRowAtIndex:)]) {
            [extension didSelectRowAtIndex:indexPath.row];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if([self numOfExtensions] > indexPath.section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:indexPath.section];
        if([extension respondsToSelector:@selector(didDeselectRowAtIndex:)]) {
            [extension didDeselectRowAtIndex:indexPath.row];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if([self numOfExtensions] > section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:section];
        if([extension respondsToSelector:@selector(getHeaderView)]) {
            return [extension getHeaderView];
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if([self numOfExtensions] > section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:section];
        if([extension respondsToSelector:@selector(getHeaderHeight)]) {
            return [extension getHeaderHeight];
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if([self numOfExtensions] > section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:section];
        if([extension respondsToSelector:@selector(getHeaderEstimatedHeight)]) {
            return [extension getHeaderEstimatedHeight];
        }
        if([extension respondsToSelector:@selector(getHeaderHeight)]) {
            return [extension getHeaderHeight];
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if([self numOfExtensions] > section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:section];
        if([extension respondsToSelector:@selector(getFooterView)]) {
            return [extension getFooterView];
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if([self numOfExtensions] > section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:section];
        if([extension respondsToSelector:@selector(getFooterHeight)]) {
            return [extension getFooterHeight];
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    if([self numOfExtensions] > section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:section];
        if([extension respondsToSelector:@selector(getFooterEstimatedHeight)]) {
            return [extension getFooterEstimatedHeight];
        }
        if([extension respondsToSelector:@selector(getFooterHeight)]) {
            return [extension getFooterHeight];
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if([self numOfExtensions] > indexPath.section) {
        id<BFTableViewCellExtension> extension = (id<BFTableViewCellExtension>)[self extensionAtIndex:indexPath.section];
        if([extension respondsToSelector:@selector(accessoryButtonTappedForIndex:)]) {
            [extension accessoryButtonTappedForIndex:indexPath.row];
        }
    }
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return [self numOfExtensions] == 0;
}


#pragma mark - DZNEmptyDataSetDelegate Helpers

- (void)reloadDataFromNetwork {
    
}

- (void)setLoadingData:(BOOL)loadingData {
    super.loadingData = loadingData;
    dispatch_async(dispatch_get_main_queue(), ^{
        // reload empty data set
        [self.tableView reloadEmptyDataSet];
    });
}


#pragma mark - UITableView Footer View Bug Fix

- (BOOL)respondsToSelector:(SEL)selector {
    if (selector == @selector(tableView:estimatedHeightForFooterInSection:)) {
        return IS_OS_9_OR_LATER;
    }
    // for any other selector just use the default implementation
    return [super respondsToSelector:selector];
}

#pragma mark - Table View Helper methods

- (BOOL)isIndexPathPresentInTableView:(NSIndexPath *)indexPath {
    return indexPath.section < [self.tableView numberOfSections] && indexPath.row < [self.tableView numberOfRowsInSection:indexPath.section];
}

- (NSIndexPath *)indexPathForIndexRowAtIndex:(NSInteger)index extension:(id<BFTableViewCellExtension>)extension {
    NSInteger sectionIndex = [self indexOfExtension:extension];
    return [NSIndexPath indexPathForRow:index inSection:sectionIndex];
}


@end
