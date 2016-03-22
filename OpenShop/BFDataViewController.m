//
//  BFDataViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFDataViewController.h"
#import "UIFont+BFFont.h"
#import "UIColor+BFColor.h"
#import "BFTableViewCellExtension.h"

@interface BFDataViewController ()

/**
 * Data extensions implementing the `BFDataExtension` protocol.
 */
@property (nonatomic, strong) NSMutableArray<id <BFDataExtension>> *dataExtensions;

/**
 * Fetches table view data from the network. This method is intended to be implemented in the subclass.
 */
- (void)reloadDataFromNetwork;

@end


@implementation BFDataViewController


#pragma mark - Initialization & Cleanup

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        self.dataExtensions = [NSMutableArray new];
    }
    return self;
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // not loading data
    self.loadingData = false;
}


#pragma mark - BFDataExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    
}

- (void)applySegueParameters:(UIViewController *)viewController {
    // apply all params if possible
    [self.segueParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([viewController respondsToSelector:NSSelectorFromString(key)]) {
            [viewController setValue:obj forKey:key];
        }
    }];
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {

}


#pragma mark - Data Extensions

- (void)addExtension:(id<BFDataExtension>)extension {
    if(extension) {
        [self.dataExtensions addObject:extension];
        if([extension respondsToSelector:@selector(didLoad)]) {
            [extension performSelector:@selector(didLoad)];
        }
    }
}

- (void)removeExtension:(id <BFDataExtension>)extension {
    [self.dataExtensions removeObject:extension];
}

- (void)removeAllExtensions {
    [self.dataExtensions removeAllObjects];
}

- (void)setExtensions:(NSArray<id<BFDataExtension>> *)extensions {
    self.dataExtensions = [NSMutableArray new];
    for(id<BFTableViewCellExtension> extension in extensions) {
        [self addExtension:extension];
    }
}

- (NSUInteger)indexOfExtension:(id<BFDataExtension>)extension {
    return [self.dataExtensions indexOfObject:extension];
}

- (id<BFDataExtension>)extensionAtIndex:(NSUInteger)index {
    return index <= [self.dataExtensions count] ? [self.dataExtensions objectAtIndex:index] : nil;
}

- (NSUInteger)numOfExtensions {
    return [self.dataExtensions count];
}

- (BOOL)containsExtension:(id<BFDataExtension>)extension {
    return [self indexOfExtension:extension] != NSNotFound;
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *titleText = _emptyDataTitle ?: BFLocalizedString(kTranslationNoItems, @"No item");
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineHeightMultiple = 1.2f;
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont BFN_robotoMediumWithSize:17],
                                 NSForegroundColorAttributeName: self.emptyDataTitleColor ?: [UIColor darkGrayColor],
                                  NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:titleText attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return _emptyDataImage;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *buttonTitleText = _emptyDataSubtitle ?: BFLocalizedString(kTranslationPressForUpdate, @"Klikni pro aktualizaci");
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont BFN_robotoBoldWithSize:15],
                                 NSForegroundColorAttributeName: self.emptyDataSubtitleColor ?: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:buttonTitleText attributes:attributes];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    // activity indicator when loading data
    if (self.loadingData) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        return activityView;
    }
    return nil;
}


#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if (!self.loadingData) {
        [self reloadDataFromNetwork];
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    if (!self.loadingData) {
        [self reloadDataFromNetwork];
    }
}


#pragma mark - DZNEmptyDataSetDelegate Helpers

- (void)reloadDataFromNetwork {
    
}



@end
