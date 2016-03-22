//
//  BFWishlistViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//



#import "BFWishlistViewController.h"
#import "BFWishlistItemsCollectionViewCellExtension.h"
#import "BFAPIManager.h"
#import "UINavigationController+BFCustomTitleView.h"
#import "BFCollectionViewLayout.h"
#import "BFAppPreferences.h"
#import "BFProductDetailViewController.h"
#import "NSArray+BFObjectFiltering.h"
#import "NSArray+BFObjectFiltering.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"
#import "BFDataRequestWishlistInfo.h"

/**
 * Maximum width of the wishlist item cell in the collection view.
 */
static CGFloat const wishlistItemMaxWidth           = 240.0f;
/**
 * Maximum height of the wishlist item cell in the collection view.
 */
static CGFloat const wishlistItemMaxHeight          = 300.0f;
/**
 * Number of visible wishlist items in the collection view.
 */
static NSUInteger const numOfVisibleItems           = 4;
/**
 * Storyboard product detail segue identifier.
 */
static NSString *const productDetailSegueIdentifier = @"productDetailSegue";
/**
 * Presenting segue wishlist item identification parameter.
 */
static NSString *const segueParameterWishlistItemID = @"wishlistItemID";


@interface BFWishlistViewController ()

/**
 * Wishlist info.
 */
@property (nonatomic, strong) BFDataRequestWishlistInfo *wishlistInfo;
/**
 * Wishlist items datasource.
 */
@property (nonatomic, strong) NSMutableArray *wishlistItems;
/**
 * Wishlist items table view cell extension.
 */
@property (nonatomic, strong) BFWishlistItemsCollectionViewCellExtension *wishlistItemsExtension;

@end


@implementation BFWishlistViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup product info
    [self setupWishlistInfo];
    
    // title view
    [self.navigationController setCustomTitleViewText:BFLocalizedString(kTranslationWishlist, @"Wishlist")];
     
    // empty data set customization
    [self customizeEmptyDataSet];
    
    // table view cell extensions
    [self setupExtensions];
    
    // update collection view
    [self setupCollectionViewLayout];
    
    // fetch data
    [self reloadDataFromNetwork];
    
    // wishlist change listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContentView) name:BFWishlistDidChangeNotification object:nil];
}


#pragma mark - Wishlist Info

- (void)setupWishlistInfo {
    if(!self.wishlistInfo) {
        self.wishlistInfo = [[BFDataRequestWishlistInfo alloc]init];
    }

    _wishlistItems = [NSMutableArray new];
}


#pragma mark - Content View Layout

- (void)setupCollectionViewLayout {
    BFCollectionViewLayout *layout = [[BFCollectionViewLayout alloc]initWithNumOfItems:numOfVisibleItems maxItemSize:CGSizeMake(wishlistItemMaxWidth, wishlistItemMaxHeight)];
    self.collectionView.collectionViewLayout = layout;
    [self updateCollectionViewLayoutForNumOfItems:numOfVisibleItems];
}

- (void)updateCollectionViewLayoutForNumOfItems:(NSUInteger)numOfItems {
    if(self.collectionView) {
        [self.collectionView performBatchUpdates:^{
            ((BFCollectionViewLayout *)self.collectionView.collectionViewLayout).numOfItems = numOfItems;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)reloadContentView {
    // cleanup datasource
    [self.wishlistItems removeAllObjects];
    _wishlistItemsExtension.wishlistItems = @[];
    // fetch data
    [self.collectionView reloadData];
    [self reloadDataFromNetwork];
}


#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // wishlsit items extension
    _wishlistItemsExtension = [[BFWishlistItemsCollectionViewCellExtension alloc]initWithCollectionViewController:self];
    _wishlistItemsExtension.wishlistItems = @[];
    
    [self setExtensions:@[_wishlistItemsExtension]];
}


#pragma mark - BFProductZoomAnimatorDelegate

- (UICollectionViewCell *)collectionViewCellForItem:(id)item {
    if([item isKindOfClass:[BFWishlistItem class]]) {
        // wishlist items row and section in the collection view
        BFWishlistItem *wishlistItem = (BFWishlistItem *)item;
        NSUInteger section = [self indexOfExtension:self.wishlistItemsExtension];
        wishlistItem = [self.wishlistItems BFN_objectForAttributeBindings:@{segueParameterWishlistItemID : wishlistItem.wishlistItemID}];
        NSUInteger row = [self.wishlistItems indexOfObject:wishlistItem];
        
        if(row != NSNotFound && section != NSNotFound) {
            return [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        }
    }
    return nil;
}


#pragma mark - Data Fetching

- (void)setLoadingData:(BOOL)loadingData {
    super.loadingData = loadingData;
}

- (void)reloadDataFromNetwork {
    // data fetching in progress
    if (self.loadingData) {
        return;
    }
    
    // loading flag
    self.loadingData = YES;
    // fetch items
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager]findWishlistContentsWithCompletionBlock:^(NSArray *records, id  customResponse, NSError *error) {
        if(error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BFError *customError = [BFError errorWithError:error];
                [customError showAlertFromSender:weakSelf];
                weakSelf.loadingData = NO;
            });
        }
        else {
            [weakSelf.wishlistItems addObjectsFromArray:records];
            weakSelf.wishlistItemsExtension.wishlistItems = weakSelf.wishlistItems;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
                weakSelf.loadingData = NO;
            });
        }
    }];
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark - DZNEmptyDataSetSource Customization

- (void)customizeEmptyDataSet {
    self.emptyDataImage = [UIImage imageNamed:@"EmptyWishlistPlaceholder"];
    self.emptyDataTitle = BFLocalizedString(kTranslationNoWishlistItems, @"No wishlist items");
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
        }
    }
}


#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    if(viewController == [BFProductDetailViewController class]) {
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:productDetailSegueIdentifier sender:self];
    }
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {
    // grouped table view background
    [[UICollectionView appearanceWhenContainedIn:self, nil] setBackgroundView:[UIView new]];
    [[UICollectionView appearanceWhenContainedIn:self, nil].backgroundView setBackgroundColor:[UIColor whiteColor]];
    [UICollectionView appearanceWhenContainedIn:self, nil].alwaysBounceVertical = true;
}




@end
