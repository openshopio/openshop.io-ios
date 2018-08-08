//
//  BFProductsFlexibleToolbar.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductsFlexibleToolbar.h"
#import "BFAppPreferences.h"
#import <Masonry.h>
#import "UIFont+BFFont.h"

/**
 * Products toolbar content transformation - scale.
 */
static CGFloat const toolbarContentTransformationScaleX        = 0.2;
static CGFloat const toolbarContentTransformationScaleY        = 0.2;
/**
 * Products toolbar content transformation - translation.
 */
static CGFloat const toolbarContentTransformationTranslationX  = 0.0;
static CGFloat const toolbarContentTransformationTranslationY  = -25.0;
/**
 * Products toolbar content final alpha value.
 */
static CGFloat const toolbarContentFinalLayoutAlpha            = 0.0;
/**
 * Products toolbar content margin.
 */
static CGFloat const toolbarContentMarginRight                 = 30.0;
/**
 * Products toolbar filter button left margin.
 */
static CGFloat const toolbarContentFilterButtonImageMarginLeft = 15.0;
/**
 * Products toolbar items spacing.
 */
static CGFloat const toolbarItemSpacing                        = 10.0;
/**
 * Products toolbar button size.
 */
static CGFloat const toolbarButtonSize                         = 40.0;
/**
 * Products toolbar background grayscale value.
 */
static CGFloat const toolbarBackgroundGrayscale                = 0.95;
/**
 * Products toolbar hit test edge insets.
 */
static CGFloat const toolbarButtonHitTestEdgeInset             = 10.0;



@interface BFProductsFlexibleToolbar ()

/**
 * The products filtering view.
 */
@property (nonatomic, strong) UIControl *filterView;
/**
 * The products sorting button.
 */
@property (nonatomic, strong) BFButton *sortButton;
/**
 * The products filtering button.
 */
@property (nonatomic, strong) BFButton *filterButton;
/**
 * The products collection view or one item type button.
 */
@property (nonatomic, strong) BFButton *viewTypeButton;


@end


@implementation BFProductsFlexibleToolbar


#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    // properties
    self.backgroundColor  = [UIColor colorWithWhite:toolbarBackgroundGrayscale alpha:1.0f];
    self.tintColor = [UIColor blackColor];
    self.hidden = true;
    self.minimumBarHeight = 0.0;
    _filtering = false;
    
    // initialization
    [self initSubviews];
    [self updateViewType];
}

- (void)initSubviews {
    [self addSubview:self.viewTypeButton];
    [self addSubview:self.filterView];
    [self addSubview:self.sortButton];
}


#pragma mark - Products View Type

- (void)updateViewType {
    switch ([[[BFAppPreferences sharedPreferences]preferredViewType]integerValue]) {
        case BFViewTypeCollection:
            [self.viewTypeButton setImage:[UIImage imageNamed:@"ProductsViewTypeCollection"] forState:UIControlStateNormal];
            break;
            
        case BFViewTypeSingleItem:
            [self.viewTypeButton setImage:[UIImage imageNamed:@"ProductsViewTypeOneItem"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}


#pragma mark - Filtering View

- (void)setFiltering:(BOOL)filtering {
    _filtering = filtering;
    if(_filtering) {
        [self.filterButton setImage:[UIImage imageNamed:@"FilterSelectedIcon"] forState:UIControlStateNormal];
    }
    else {
        [self.filterButton setImage:[UIImage imageNamed:@"FilterUnselectedIcon"] forState:UIControlStateNormal];
    }
}


#pragma mark - Toolbar Content

- (BFButton *)viewTypeButton {
    if (!_viewTypeButton) {
        _viewTypeButton = [BFButton buttonWithType:UIButtonTypeCustom];
        [_viewTypeButton setFrame:CGRectMake(0, 0, toolbarButtonSize*2, toolbarButtonSize)];
        [_viewTypeButton addTarget:self action:@selector(switchCollectionViewLayout:) forControlEvents:UIControlEventTouchUpInside];
        _viewTypeButton.hitTestEdgeInsets = UIEdgeInsetsMake(-toolbarButtonHitTestEdgeInset, -toolbarButtonHitTestEdgeInset, -toolbarButtonHitTestEdgeInset, -toolbarButtonHitTestEdgeInset);
        // setup layout attributes
        [self setLayoutAttributesForView:_viewTypeButton withCenter:CGPointMake(CGRectGetMinX(self.bounds) + CGRectGetWidth(self.viewTypeButton.bounds)/2, CGRectGetMidY(self.bounds))];
    }
    return _viewTypeButton;
}

- (UIControl *)filterView {
    if (!_filterView) {
        _filterView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, toolbarButtonSize*2, toolbarButtonSize)];
        
        // filter button
        _filterButton = [BFButton buttonWithType:UIButtonTypeCustom];
        [_filterButton setFrame:CGRectMake(0, 0, toolbarButtonSize, toolbarButtonSize)];
        _filterButton.hitTestEdgeInsets = UIEdgeInsetsMake(-toolbarButtonHitTestEdgeInset, -2*toolbarButtonHitTestEdgeInset, -toolbarButtonHitTestEdgeInset, -toolbarButtonHitTestEdgeInset-toolbarButtonSize);
        [_filterButton setImage:[UIImage imageNamed:@"FilterUnselectedIcon"] forState:UIControlStateNormal];
        [_filterButton addTarget:self action:@selector(filterProducts:) forControlEvents:UIControlEventTouchDown];
    
        // filter button label
        UILabel *filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, toolbarButtonSize/4, toolbarButtonSize, toolbarButtonSize/2)];
        [filterLabel setFont:[UIFont BFN_robotoRegularWithSize:13]];
        [filterLabel setTextColor:[UIColor blackColor]];
        [filterLabel setBackgroundColor:[UIColor clearColor]];
        [filterLabel setTextAlignment:NSTextAlignmentCenter];
        [filterLabel setText:BFLocalizedString(kTranslationFilter, @"Filter")];
        [filterLabel sizeToFit];
        
        [_filterView addSubview:_filterButton];
        [_filterView addSubview:filterLabel];
    
        [_filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->_filterView);
            make.left.equalTo(self->_filterView).with.mas_offset(@(toolbarContentFilterButtonImageMarginLeft));
        }];
        [filterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->_filterButton);
            make.left.equalTo(self->_filterButton.mas_right).with.mas_offset(@(toolbarItemSpacing));
        }];
        
        // setup layout attributes
        [self setLayoutAttributesForView:_filterView withCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
    }
    return _filterView;
}

- (BFButton *)sortButton {
    if (!_sortButton) {
        _sortButton = [BFButton buttonWithType:UIButtonTypeCustom];
        [_sortButton setFrame:CGRectMake(0, 0, toolbarButtonSize, toolbarButtonSize)];
        [_sortButton setImage:[UIImage imageNamed:@"SortIcon"] forState:UIControlStateNormal];
        [_sortButton addTarget:self action:@selector(sortProducts:) forControlEvents:UIControlEventTouchUpInside];
        _sortButton.hitTestEdgeInsets = UIEdgeInsetsMake(-toolbarButtonHitTestEdgeInset, -toolbarButtonHitTestEdgeInset, -toolbarButtonHitTestEdgeInset, -toolbarButtonHitTestEdgeInset);
        // setup layout attributes
        [self setLayoutAttributesForView:_sortButton withCenter:CGPointMake(CGRectGetMaxX(self.bounds) - toolbarContentMarginRight, CGRectGetMidY(self.bounds))];
    }
    return _sortButton;
}


#pragma mark - Layout Attributes

- (void)setLayoutAttributesForView:(UIView*)view withCenter:(CGPoint)center {
    // initial layout
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    initialLayoutAttributes.size = view.frame.size;
    initialLayoutAttributes.center = center;
    // this is what we want the bar to look like at its maximum height (progress == 0.0)
    [view addLayoutAttributes:initialLayoutAttributes forProgress:0.0f];
    
    // final set of layout attributes based on the same values as the initial layout attributes
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialLayoutAttributes];
    // visibility
    finalLayoutAttributes.alpha = toolbarContentFinalLayoutAlpha;
    // transformation
    CGAffineTransform translation = CGAffineTransformMakeTranslation(toolbarContentTransformationTranslationX, toolbarContentTransformationTranslationY);
    CGAffineTransform scale = CGAffineTransformMakeScale(toolbarContentTransformationScaleX, toolbarContentTransformationScaleY);
    finalLayoutAttributes.transform = CGAffineTransformConcat(scale, translation);
    // this is what we want the bar to look like at its minimum height (progress == 1.0)
    [view addLayoutAttributes:finalLayoutAttributes forProgress:1.0f];
}


#pragma mark - BFProductsToolbarDelegate

- (IBAction)switchCollectionViewLayout:(id)sender {
    BFViewType viewType = (BFViewType)[[[BFAppPreferences sharedPreferences]preferredViewType]integerValue];
    viewType = (viewType == BFViewTypeSingleItem) ? BFViewTypeCollection : BFViewTypeSingleItem;
    // save the view type
    [[BFAppPreferences sharedPreferences]setPreferredViewType:@(viewType)];
    [self updateViewType];
    
    if(self.delegate) {
        [self.delegate setProductsViewType:viewType];
    }
}

- (IBAction)sortProducts:(id)sender {
    if(self.delegate) {
        [self.delegate sortProducts];
    }
}

- (IBAction)filterProducts:(id)sender {
    if(self.delegate) {
        [self.delegate filterProducts];
    }
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {

}


@end
