//
//  BFFilterViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFFilterViewController.h"
#import "BFProductsViewController.h"
#import "BFFilterPriceTableViewCellExtension.h"
#import "BFFilterSelectionItemsTableViewCellExtension.h"
#import "BFSelectionViewController.h"
#import "BFProductBrand.h"

/**
 * Buttons footer view height.
 */
static CGFloat const filterButtonsFooterViewHeight = 90.0f;
/**
 * Filter cancel button border width.
 */
static CGFloat const buttonBorderWidth             = 0.0f;
/**
 * Storyboard products segue identifier.
 */
static NSString *const selectionSegueIdentifier    = @"selectionSegue";
/**
 * Presenting segue filter type parameter.
 */
static NSString *const segueParameterFilterType    = @"filterType";



@interface BFFilterViewController ()

/**
 * Products filtering with a price range table view extension.
 */
@property (nonatomic, strong) BFFilterPriceTableViewCellExtension *priceExtension;
/**
 * Products filtering with options using the list selection interface table view extension.
 */
@property (nonatomic, strong) BFFilterSelectionItemsTableViewCellExtension *selectionItemsExtension;
/**
 * Filter cancellation button.
 */
@property (nonatomic, weak) IBOutlet BFButton *cancelButton;
/**
 * Filter confirmation button.
 */
@property (nonatomic, weak) IBOutlet BFButton *doneButton;
/**
 * Flag indicating wheter whe filtering attributes have been modified.
 */
@property (nonatomic, assign) BOOL filterUpdated;

@end


@implementation BFFilterViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // title view
    self.navigationItem.title = [BFLocalizedString(kTranslationFilter, @"Filter") uppercaseString];
    
    // extensions setup
    [self setupExtensions];
    
    // setup footer view
    [self setupFooter];
}


#pragma mark - Footer View

- (void)setupFooter {
    // update buttons footer view
    UIView *footerView = self.tableView.tableFooterView;
    CGRect frame = footerView.frame;
    frame.size.height = filterButtonsFooterViewHeight;
    footerView.frame = frame;
    self.tableView.tableFooterView = footerView;
    
    self.cancelButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.cancelButton.layer.borderWidth = buttonBorderWidth;
}


#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // default values
    [self removeAllExtensions];
    
    // shops extension
    _priceExtension = [[BFFilterPriceTableViewCellExtension alloc]initWithTableViewController:self];
    _priceExtension.productPriceRange = self.filterAttributes.productPriceRange;
    _priceExtension.selectedPriceRange = self.filterAttributes.selectedProductPriceRange;
    _priceExtension.currency = self.currency;
    __weak __typeof__(self) weakSelf = self;
    _priceExtension.priceRangeChanged = ^(BFProductPriceRange *priceRange) {
        weakSelf.filterAttributes.selectedProductPriceRange = priceRange;
        weakSelf.filterUpdated = true;
    };
    
    _selectionItemsExtension = [[BFFilterSelectionItemsTableViewCellExtension alloc]initWithTableViewController:self];
    _selectionItemsExtension.filterAttributes = self.filterAttributes;
    
    [self setExtensions:@[_priceExtension, _selectionItemsExtension]];
    [self.tableView reloadEmptyDataSet];
}

- (void)updateSelectionItemExtensions {
    _selectionItemsExtension.filterAttributes = self.filterAttributes;
    [self.tableView reloadData];
}


#pragma mark - Button Actions

- (IBAction)doneClicked:(id)sender {
    if(self.filterUpdated && self.filterAttributesChanged) {
        self.filterAttributesChanged(self.filterAttributes);
    }
    [self dismissAnimated:YES];
}

- (IBAction)cancelClicked:(id)sender {
    [self dismissAnimated:YES];
}


#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // products controller
    if ([[segue identifier] isEqualToString:selectionSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFSelectionViewController class]]) {
            BFSelectionViewController *selectionController = (BFSelectionViewController *)segue.destinationViewController;
            NSNumber *filterType = [self.segueParameters objectForKey:segueParameterFilterType];
            
            // selection options
            __weak __typeof__(self) weakSelf = self;
            if(filterType && (BFNFilterType)[filterType integerValue] == BFNProductFilterTypeSize) {
                selectionController.sortAlphabetically = false;
                selectionController.fastNavigation = false;
            }
            // multiselection not supported yet
            selectionController.multiSelection = false;
            
            // callback with block
            selectionController.selectedItemsCallback = ^(NSArray<id<BFNSelection>> *selectedItems, NSArray<id<BFNSelection>> *items) {
                [weakSelf.filterAttributes setSelectedFilterItems:selectedItems ofFilterType:(BFNFilterType)[filterType integerValue]];
                [weakSelf updateSelectionItemExtensions];
                weakSelf.filterUpdated = true;
            };
            
            [self applySegueParameters:selectionController];
        }
    }
}


#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    if(viewController == [BFProductsViewController class]) {
        // return back
        [self dismissAnimated:YES];
    }
    else if(viewController == [BFSelectionViewController class]) {
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:selectionSegueIdentifier sender:self];
    }
}


@end


