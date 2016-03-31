//
//  BFProductsViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFProductsViewController.h"
#import "BFProductsCollectionViewCellExtension.h"
#import "BFAPIManager.h"
#import <BLKDelegateSplitter.h>
#import <FacebookStyleBarBehaviorDefiner.h>
#import "UINavigationController+BFCustomTitleView.h"
#import "BFCollectionViewLayout.h"
#import "BFAppPreferences.h"
#import "BFSortViewController.h"
#import "BFProductDetailViewController.h"
#import "NSArray+BFObjectFiltering.h"
#import "BFProductFilterAttributes.h"
#import "BFFilterViewController.h"
#import "BFFilterViewController.h"
#import "NSArray+BFObjectFiltering.h"

/**
 * Number of products fetched in a single request.
 */
static NSUInteger const productsFetchPageSize           = 8;
/**
 * Products toolbar initial height.
 */
static CGFloat const productsToolbarHeight              = 50.0;
/**
 * Products toolbar slide animation duration.
 */
static CGFloat const productsToolbarAnimationDuration   = 0.4;
/**
 * Maximum width of the product cell in the collection view.
 */
static CGFloat const productItemMaxWidth                = 300.0;
/**
 * Maximum height of the product cell in the collection view.
 */
static CGFloat const productItemMaxHeight               = 450.0;
/**
 * Maximum width of the product cell in the collection view on iPad.
 */
static CGFloat const productItemMaxWidthIPad            = 600.0;
/**
 * Maximum height of the product cell in the collection view on iPad.
 */
static CGFloat const productItemMaxHeightIPad           = 750.0;
/**
 * Number of visible products in the single view type.
 */
static NSUInteger const numOfItemsForSingleViewType     = 1;
/**
 * Number of visible products in the collection view type.
 */
static NSUInteger const numOfItemsForCollectionViewType = 4;
/**
 * Item height resize ratio.
 */
static CGFloat const itemHeightResizeRatio              = 1.3;
/**
 * Item width resize ratio.
 */
static CGFloat const itemWidthResizeRatio               = 1.0;
/**
 * Storyboard product detail segue identifier.
 */
static NSString *const productDetailSegueIdentifier     = @"productDetailSegue";
/**
 * Storyboard sorting view segue identifier.
 */
static NSString *const sortSegueIdentifier              = @"sortSegue";
/**
 * Storyboard filtering view segue identifier.
 */
static NSString *const filterSegueIdentifier            = @"filterSegue";



@interface BFProductsViewController ()

/**
 * Products toolbar.
 */
@property (nonatomic, strong) BFProductsFlexibleToolbar *toolbar;
/**
 * Table view delegate splitter (required to assign multiple delegates for a single table view).
 */
@property (nonatomic, strong) BLKDelegateSplitter *delegateSplitter;
/**
 * Products filtering attributes.
 */
@property (nonatomic, strong) BFProductFilterAttributes *filterAttributes;
/**
 * Products datasource.
 */
@property (nonatomic, strong) NSMutableArray *products;
/**
 * Flag indicating whether all products have been already fetched.
 */
@property (nonatomic, assign) BOOL didLoadAllProducts;
/**
 * Flag indicating whether the product detail is being presented.
 */
@property (nonatomic, assign) BOOL isPresentingProductDetail;
/**
 * Flag indicating whether the products have been fetched when the view was invisible.
 */
@property (nonatomic, assign) BOOL didFetchDataWhenNotVisible;
/**
 * Table view top layout contraint.
 */
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;
/**
 * Products collection view cell extension.
 */
@property (nonatomic, strong) BFProductsCollectionViewCellExtension *productsExtension;


@end

@implementation BFProductsViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup product info
    [self setupProductInfo];
    
    // title view
    [self.navigationController setCustomTitleViewText:[(NSString *)self.productInfo.resultsTitle uppercaseString]];
    
    // empty data set customization
    [self customizeEmptyDataSet];
    
    // collection view cell extensions
    [self setupExtensions];
    
    // setup toolbar
    [self setupToolbar];
    
    // update collection view
    [self setupCollectionViewLayout];
    
    // fetch data
    [self reloadDataFromNetwork];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // hide toolbar if not presenting the product detail
    if(!self.isPresentingProductDetail) {
        [self setToolbarHidden:true animated:false];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // show toolbar if not presenting the product detail
    if ((!self.isPresentingProductDetail && self.productsExtension && self.productsExtension.products.count) || self.toolbar.filtering) {
        [self setToolbarHidden:false animated:true];
    }
    self.isPresentingProductDetail = false;
    // reload collection view if data has been fetched when view was invisible
    if(self.didFetchDataWhenNotVisible) {
        [self.collectionView reloadData];
        self.didFetchDataWhenNotVisible = false;
    }
}


#pragma mark - Toolbar

- (BFProductsFlexibleToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[BFProductsFlexibleToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, productsToolbarHeight)];
        _toolbar.delegate = self;
    }
    return _toolbar;
}

- (void)setupToolbar {
    [self.view addSubview:self.toolbar];
    self.toolbar.behaviorDefiner = [[FacebookStyleBarBehaviorDefiner alloc] init];
    // split the delegate
    self.delegateSplitter = [[BLKDelegateSplitter alloc] initWithFirstDelegate:self.toolbar.behaviorDefiner secondDelegate:self];
    self.collectionView.delegate = (id<UICollectionViewDelegate>)self.delegateSplitter;
}

- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated {
    self.toolbar.hidden = hidden;
    
    [self.view setNeedsUpdateConstraints];
    if (animated) {
        [UIView animateWithDuration:productsToolbarAnimationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}


#pragma mark - Content View Layout

- (void)setupCollectionViewLayout {
    BFViewType viewType = (BFViewType)[[[BFAppPreferences sharedPreferences]preferredViewType]integerValue];
    NSUInteger numOfItems = (viewType == BFViewTypeSingleItem) ? numOfItemsForSingleViewType : numOfItemsForCollectionViewType;
    
    CGSize collectionViewLayoutMaxItemSize;
    // Ipad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        collectionViewLayoutMaxItemSize = CGSizeMake(productItemMaxWidthIPad, productItemMaxHeightIPad);
    }
    // Iphone
    else {
        collectionViewLayoutMaxItemSize = CGSizeMake(productItemMaxWidth, productItemMaxHeight);
    }
    
    BFCollectionViewLayout *layout = [[BFCollectionViewLayout alloc]initWithNumOfItems:numOfItems maxItemSize:collectionViewLayoutMaxItemSize heightResizeRatio:itemHeightResizeRatio widthResizeRatio:itemWidthResizeRatio];
    self.collectionView.collectionViewLayout = layout;
    
    [self updateCollectionViewLayoutForViewType:viewType];
}

- (void)updateCollectionViewLayoutForViewType:(BFViewType)viewType {
    NSUInteger numOfItems = (viewType == BFViewTypeSingleItem) ? numOfItemsForSingleViewType : numOfItemsForCollectionViewType;
    
    if(self.collectionView) {
        [self.collectionView performBatchUpdates:^{
            ((BFCollectionViewLayout *)self.collectionView.collectionViewLayout).numOfItems = numOfItems;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)reloadContentViewWithToolbar:(BOOL)reloadToolbar {
    if(self.view.window) {
        [self.collectionView layoutIfNeeded];
        [self.collectionView reloadData];
    
        // reload toolbar
        if(reloadToolbar) {
            [UIView animateWithDuration:1.0 animations:^{
                self.toolbar.progress = 0.0;
                [self.toolbar setNeedsLayout];
                [self.toolbar layoutIfNeeded];
            }];
        }
    }
    else {
        self.didFetchDataWhenNotVisible = true;
    }
}


#pragma mark - Filtering Attributes

- (void)setFilterAttributes:(BFProductFilterAttributes *)filterAttributes {
    _filterAttributes = filterAttributes;
    [self.toolbar setFiltering:[self updateProductInfoWithFilterAttributes]];
}

- (BOOL)updateProductInfoWithFilterAttributes {
    BOOL filtering = false;
    self.productInfo.colors = nil;
    self.productInfo.sizes = nil;
    self.productInfo.brands = nil;
    self.productInfo.priceRange = nil;
    
    if(_filterAttributes) {
        if(_filterAttributes.selectedProductPriceRange) {
            BFProductPriceRange *priceRange = _filterAttributes.selectedProductPriceRange;
            if(![priceRange.min isEqualToNumber:_filterAttributes.productPriceRange.min] || ![priceRange.max isEqualToNumber:_filterAttributes.productPriceRange.max]) {
                filtering = true;
                NSRange priceRange = NSMakeRange([_filterAttributes.selectedProductPriceRange.min integerValue], [_filterAttributes.selectedProductPriceRange.max integerValue]-[_filterAttributes.selectedProductPriceRange.min integerValue]);
                self.productInfo.priceRange = [NSValue valueWithRange:priceRange];
            }
        }
        if(_filterAttributes.selectedProductVariantColors && [_filterAttributes.selectedProductVariantColors count]) {
            filtering = true;
            self.productInfo.colors = [_filterAttributes.selectedProductVariantColors BFN_distinctValuesOfAttribute:@"colorID"];
        }
        if(_filterAttributes.selectedProductVariantSizes && [_filterAttributes.selectedProductVariantSizes count]) {
            filtering = true;
            self.productInfo.sizes = [_filterAttributes.selectedProductVariantSizes BFN_distinctValuesOfAttribute:@"sizeID"];
        }
        if(_filterAttributes.selectedProductBrands && [_filterAttributes.selectedProductBrands count]) {
            filtering = true;
            self.productInfo.brands = [_filterAttributes.selectedProductBrands BFN_distinctValuesOfAttribute:@"brandID"];
        }
    }
    
    return filtering;
}


#pragma mark - View Layout & Constraints

- (void)updateViewConstraints {
    if(self.collectionView) {
        [self updateCollectionViewConstraintsWithToolbar:self.toolbar.hidden];
    }
    [super updateViewConstraints];
}

- (void)updateCollectionViewConstraintsWithToolbar:(BOOL)hidden {
    // update the table view top constraint
    [self.view removeConstraint:self.topConstraint];
    
    self.topConstraint = [NSLayoutConstraint constraintWithItem:(UICollectionView *)self.collectionView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:hidden ? self.view : self.toolbar
                                                      attribute:hidden ? NSLayoutAttributeTop : NSLayoutAttributeBottom
                                                     multiplier:1.0
                                                       constant:0.0];
    
    [self.view addConstraint:self.topConstraint];
}


#pragma mark - Product Info

- (void)setupProductInfo {
    if(!self.productInfo) {
        self.productInfo = [[BFDataRequestProductInfo alloc]initWithOffset:@0 limit:@(productsFetchPageSize)];
    }
    
    if(!self.productInfo.resultsTitle) {
        self.productInfo.resultsTitle = BFLocalizedString(kTranslationProducts, @"Products");
    }
    
    if(!self.productInfo.offset && !self.productInfo.limit) {
        self.productInfo.offset = @0;
        self.productInfo.limit = @(productsFetchPageSize);
    }
    
    if(!self.productInfo.sortType) {
        self.productInfo.sortType = [[BFAppPreferences sharedPreferences]preferredSortType];
    }
    
    _products = [NSMutableArray new];
    _filterAttributes = [[BFProductFilterAttributes alloc]init];
}


#pragma mark - Collection View Cell Extensions

- (void)setupExtensions {
    // products extension
    _productsExtension = [[BFProductsCollectionViewCellExtension alloc]initWithCollectionViewController:self];
    _productsExtension.products = @[];
    
    [self setExtensions:@[_productsExtension]];
}

- (void)cleanDataSource {
    // remove all retrieved products
    if(_productsExtension) {
        _productsExtension.products = @[];
    }
    
    [self.products removeAllObjects];
    // scroll to top to display empty data set correctly
    [self.collectionView setContentOffset:CGPointZero];
    
    [self.collectionView reloadData];
    [self setToolbarHidden:true animated:false];
    
    // default values
    self.loadingData = false;
    self.didLoadAllProducts = false;
    self.productInfo.offset = @0;
    
}


#pragma mark - BFProductZoomAnimatorDelegate

- (UICollectionViewCell *)collectionViewCellForItem:(id)item {
    if([item isKindOfClass:[BFProduct class]]) {
        // product row and section in the collection view
        BFProduct *product = (BFProduct *)item;
        NSUInteger section = [self indexOfExtension:self.productsExtension];
        product = [self.products BFN_objectForAttributeBindings:@{@"productID" : product.productID}];
        NSUInteger row = [self.products indexOfObject:product];
        
        if(row != NSNotFound && section != NSNotFound) {
            return [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        }
    }
    
    return nil;
}


#pragma mark - Data Fetching

- (void)setDidLoadAllProducts:(BOOL)didLoadAllProducts {
    _didLoadAllProducts = didLoadAllProducts;
    if(self.productsExtension) {
        self.productsExtension.showsFooter = !didLoadAllProducts;
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
    
    // fetch products
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager]findProductsWithInfo:self.productInfo completionBlock:^(NSArray *records, id customResponse, NSError *error) {
        // error results
        if(error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BFError *customError = [BFError errorWithError:error];
                [customError showAlertFromSender:weakSelf];
                weakSelf.loadingData = NO;
            });
        }
        else {
            // initial show of top toolbar
            if (records.count > 0 && weakSelf.products.count == 0 && weakSelf.view.window) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf setToolbarHidden:NO animated:YES];
                });
            }
            
            // save filtering attributes
            if(!weakSelf.toolbar.filtering) {
                [weakSelf.filterAttributes addFilterItems:customResponse];
            }
            [weakSelf.products addObjectsFromArray:records];
            weakSelf.productsExtension.products = weakSelf.products;
    
            weakSelf.productInfo.offset = @([weakSelf.productInfo.offset unsignedIntegerValue] + productsFetchPageSize);
            weakSelf.didLoadAllProducts = records.count < productsFetchPageSize;
         
            // reload content view
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reloadContentViewWithToolbar:false];
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
    self.emptyDataImage = [UIImage imageNamed:@"EmptyCategoriesPlaceholder"];
    self.emptyDataTitle = BFLocalizedString(kTranslationNoProducts, @"No products");
}


#pragma mark - DZNEmptyDataSetDelegate

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
            self.isPresentingProductDetail = true;
        }
    }
    // sorting controller
    else if ([[segue identifier] isEqualToString:sortSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UIViewController *rootViewController = [((UINavigationController *)segue.destinationViewController).viewControllers firstObject];
            if([rootViewController isKindOfClass:[BFSortViewController class]]) {            
                BFSortViewController *sortController = (BFSortViewController *)rootViewController;
                __weak __typeof__(self) weakSelf = self;
                sortController.preCompletion = ^() {
                    // save products sort type
                    if(![weakSelf.productInfo.sortType isEqualToNumber:(NSNumber *)[[BFAppPreferences sharedPreferences]preferredSortType]]) {
                        weakSelf.productInfo.sortType = [[BFAppPreferences sharedPreferences]preferredSortType];
                        // reload data
                        [weakSelf cleanDataSource];
                        [weakSelf reloadDataFromNetwork];
                    }
                };
            }
        }
    }
    // filtering controller
    else if ([[segue identifier] isEqualToString:filterSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UIViewController *rootViewController = [((UINavigationController *)segue.destinationViewController).viewControllers firstObject];
            if([rootViewController isKindOfClass:[BFFilterViewController class]]) {
                BFFilterViewController *filterController = (BFFilterViewController *)rootViewController;
                filterController.filterAttributes = [self.filterAttributes copy];
                filterController.currency = self.products.count && [[self.products firstObject]currency] ? (NSString *)[[self.products firstObject]currency] : @"CZK";
                __weak __typeof__(self) weakSelf = self;
                filterController.filterAttributesChanged = ^(BFProductFilterAttributes *filterAttributes) {
                    weakSelf.filterAttributes = filterAttributes;
                    // reload data
                    [weakSelf cleanDataSource];
                    [weakSelf reloadDataFromNetwork];
                };
            }
        }
    }
}


#pragma mark - BFDataExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    if(viewController == [BFProductDetailViewController class]) {
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:productDetailSegueIdentifier sender:self];
    }
}


#pragma mark - BFProductsToolbarDelegate

- (void)setProductsViewType:(BFViewType)viewType {
    if(self.productsExtension) {
        [self.productsExtension resetCache];
    }

    [self updateCollectionViewLayoutForViewType:viewType];
}

- (void)sortProducts {
    [self performSegueWithIdentifier:sortSegueIdentifier sender:self];
}

- (void)filterProducts {
    [self performSegueWithIdentifier:filterSegueIdentifier sender:self];
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {
    // grouped table view background
    [[UICollectionView appearanceWhenContainedIn:self, nil] setBackgroundView:[UIView new]];
    [[UICollectionView appearanceWhenContainedIn:self, nil].backgroundView setBackgroundColor:[UIColor whiteColor]];
    [UICollectionView appearanceWhenContainedIn:self, nil].alwaysBounceVertical = true;
}




@end
