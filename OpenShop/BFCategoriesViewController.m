//
//  BFCategoriesViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCategoriesViewController.h"
#import "BFAPIManager.h"
#import "BFTabBarController.h"
#import "NSObject+BFStoryboardInitialization.h"
#import "UIFont+BFFont.h"
#import "BFCategoryTableViewCellExtension.h"
#import "BFStaticCategoriesTableViewCellExtension.h"
#import "UINavigationController+BFCustomTitleView.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"
#import "BFAppPreferences.h"
#import "BFTableViewHeaderFooterView.h"
#import "BFProductsViewController.h"

/**
 * Storyboard products segue identifier.
 */
static NSString *const productsSegueIdentifier = @"productsSegue";
/**
 * Presenting segue product information parameter.
 */
static NSString *const segueParameterProductInfo         = @"productInfo";


@interface BFCategoriesViewController ()

/**
 * Static categories table view cell extension.
 */
@property (nonatomic, strong) BFStaticCategoriesTableViewCellExtension *staticCategoriesExtension;
/**
 * Currently opened top level category table view cell extension.
 */
@property (nonatomic, assign) BFCategoryTableViewCellExtension *openedCategoryExtension;

@end


@implementation BFCategoriesViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // iOS 8 background fix
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    // title view
    [self.navigationController setCustomTitleViewImage:[UIImage imageNamed:@"LogoOpenShopBlack" ]];

    // empty data set customization
    [self customizeEmptyDataSet];
    
    // initial categories fetch
    [self reloadDataFromNetwork];

    // language changed notification observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangedAction) name:BFLanguageDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark - Table View Cell Extensions

- (void)setupExtensions:(NSArray *)categories {
    // default values
    self.openedCategoryExtension = nil;
    [self removeAllExtensions];
    
    // display static categories if allowed
    if(self.displaysStaticCategories) {
        _staticCategoriesExtension = [[BFStaticCategoriesTableViewCellExtension alloc]initWithTableViewController:self];
        [self addExtension:_staticCategoriesExtension];
    }
    // extension for each category
    for(BFCategory *category in categories) {
        // category extension
        BFCategoryTableViewCellExtension *categoryExtension = [[BFCategoryTableViewCellExtension alloc]initWithTableViewController:self];
        categoryExtension.category = category;
        [self addExtension:categoryExtension];
    }
}

- (void)cleanDataSource {
    // remove all retrieved categories and display just static categories if allowed
    if(self.displaysStaticCategories) {
        _staticCategoriesExtension = [[BFStaticCategoriesTableViewCellExtension alloc]initWithTableViewController:self];
        [self setExtensions:@[_staticCategoriesExtension]];
    }
    else {
        // remove all retrieved categories
        [self removeAllExtensions];
    }
    // scroll to top to display empty data set correctly
    [self.tableView setContentOffset:CGPointZero];
    [self.tableView reloadData];
}


#pragma mark - BFTopLevelCategoryViewDelegate

- (void)categorySectionStateChanged:(BOOL)opened onExtension:(id<BFTableViewCellExtension>)extension {
    NSUInteger sectionIndex = [self indexOfExtension:extension];
    // extension not found
    if(sectionIndex == NSNotFound || ![extension isKindOfClass:[BFCategoryTableViewCellExtension class]]) {
        return;
    }
    
    BFCategoryTableViewCellExtension *categoryExtension = (BFCategoryTableViewCellExtension *)extension;
    // number of rows to insert
    NSUInteger numOfRows = categoryExtension.category ? categoryExtension.category.children.count : 0;
    // insert index paths calculation
    NSMutableArray *insertIndexPaths = [NSMutableArray new];
    if(opened) {
        for (int i = 0; i < numOfRows; i++) {
            [insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
        }
    }
    
    // delete index paths calculation
    NSMutableArray *deleteIndexPaths = [NSMutableArray new];
    NSUInteger openedSectionIndex = NSNotFound;
    if(self.openedCategoryExtension) {
        // close previously opened category section
        [self.openedCategoryExtension setOpened:false animated:true interaction:true];
        // opened section index
        openedSectionIndex = [self indexOfExtension:self.openedCategoryExtension];
        if(openedSectionIndex != NSNotFound) {
            // number of rows to delete
            numOfRows = self.openedCategoryExtension.category ? self.openedCategoryExtension.category.children.count : 0;
            for (int i = 0; i < numOfRows; i++) {
                [deleteIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:openedSectionIndex]];
            }
        }
    }
    
    // save opened extension
    self.openedCategoryExtension = opened ? categoryExtension : nil;
    
    // scroll to the top of the selected parent category
    UITableViewRowAnimation insertAnimation = self.openedCategoryExtension && sectionIndex < openedSectionIndex ? UITableViewRowAnimationTop : UITableViewRowAnimationBottom;
    UITableViewRowAnimation deleteAnimation = self.openedCategoryExtension && sectionIndex < openedSectionIndex ? UITableViewRowAnimationBottom : UITableViewRowAnimationTop;
    // table view update
    [self.tableView beginUpdates];
    // notify selected extension
    [self.openedCategoryExtension setOpened:opened animated:false interaction:false];
    // insert and delete rows
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    // scroll to the opened category section
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:sectionIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)categorySectionActionOnExtension:(id<BFTableViewCellExtension>)extension {
    // extension not found
    if(![extension isKindOfClass:[BFCategoryTableViewCellExtension class]]) {
        return;
    }
    
    // category has no children -> open the category itself
    BFCategoryTableViewCellExtension *categoryExtension = (BFCategoryTableViewCellExtension *)extension;
    BFCategory *childCategory = categoryExtension.category;
    // category products
    BFDataRequestProductInfo *productInfo = [[BFDataRequestProductInfo alloc]init];
    [productInfo setCategoryID:childCategory.originalID];
    [self performSegueWithViewController:[BFProductsViewController class] params:@{segueParameterProductInfo : productInfo}];
}

#pragma mark - Data Fetching

- (void)reloadDataFromNetwork {
    // data fetching flag
    self.loadingData = true;
    // empty data source
    [self cleanDataSource];
    
    // fetch categories
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager]findCategoriesWithMenuCategory:(BFMenuCategory)[[[BFAppPreferences sharedPreferences]preferredMenuCategory]integerValue] completionBlock:^(NSArray *records, id customResponse, NSError *error) {
        // error results
        if(error) {
            BFError *customError = [BFError errorWithError:error];
            [customError showAlertFromSender:weakSelf];
        }
        else {
            // add categories as the search suggestions
            [[StorageManager defaultManager] addSearchSuggestionsFromCategories:records];
            
            // setup extension
            [weakSelf setupExtensions:records];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // data fetching flag
            weakSelf.loadingData = false;
        });
    }];
}

- (void)setLoadingData:(BOOL)loadingData {
    [super setLoadingData:loadingData];
    [self.tableView reloadData];
}


#pragma mark - Properties Setters

- (void)setDisplaysStaticCategories:(BOOL)displaysStaticCategories {
    _displaysStaticCategories = displaysStaticCategories;
    [self.tableView reloadData];
}


#pragma mark - UISegmentedControlDelegate

- (IBAction)segmentedControlValueDidChange:(UISegmentedControl *)segmentedControl {
    // save preferred menu category
    BFMenuCategory menuCategory = (BFMenuCategory)segmentedControl.selectedSegmentIndex;
    [[BFAppPreferences sharedPreferences]setPreferredMenuCategory:@(menuCategory)];
    // reload data
    [self reloadDataFromNetwork];
}

#pragma mark - Language changed notification

- (void)languageChangedAction {
    // fetch data
    [self reloadDataFromNetwork];
}

#pragma mark - DZNEmptyDataSetSource Customization

- (void)customizeEmptyDataSet {
    self.emptyDataImage = [UIImage imageNamed:@"EmptyCategoriesPlaceholder"];
    self.emptyDataTitle = BFLocalizedString(kTranslationNoCategoriesHeadline, @"No categories");
}


#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // products controller
    if ([[segue identifier] isEqualToString:productsSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFProductsViewController class]]) {
            BFProductsViewController *productsController = (BFProductsViewController *)segue.destinationViewController;
            [self applySegueParameters:productsController];
        }
    }
}


#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    if(viewController == [BFProductsViewController class]) {
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:productsSegueIdentifier sender:self];
    }
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {
    // no separator
    [UITableView appearanceWhenContainedIn:self, nil].separatorColor = [UIColor clearColor];
    // grouped table view background
    [[UITableView appearanceWhenContainedIn:self, nil] setBackgroundView:nil];
    [[UITableView appearanceWhenContainedIn:self, nil] setBackgroundColor:[UIColor whiteColor]];
    
    // segmented control title text
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineHeightMultiple = 1.2f;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = NSTextAlignmentCenter;
    [[UISegmentedControl appearanceWhenContainedIn:self, nil] setTitleTextAttributes:@{
                                                                                       NSFontAttributeName:[UIFont BFN_robotoMediumWithSize:16],
                                                                                       NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                       NSParagraphStyleAttributeName : style
                                                                                      } forState:UIControlStateSelected];
    [[UISegmentedControl appearanceWhenContainedIn:self, nil] setTitleTextAttributes:@{
                                                                                       NSFontAttributeName:[UIFont BFN_robotoLightWithSize:15],
                                                                                       NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                       NSParagraphStyleAttributeName : style
                                                                                       } forState:UIControlStateNormal];
}

@end
