//
//  BFTableViewHeaderFooterView.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

/**
 * `BFTableViewHeaderFooterView` is a base table view header or footer view wrapper
 * to be subclassed for further use if needed. It contains basic properties and it
 * manages their appearance according to the requirements.
 */
@interface BFTableViewHeaderFooterView : UITableViewHeaderFooterView

/**
 * The activity indicator.
 */
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
/**
 * Header text label.
 */
@property (nonatomic, weak) IBOutlet UILabel *headerlabel;
/**
 * Action button.
 */
@property (nonatomic, weak) IBOutlet UIButton *actionButton;
/**
 * Action button block callback.
 */
@property (nonatomic, copy) void (^actionButtonBlock)(void);

/**
 * Updates content view horizontal margin.
 *
 * @param margin The horizontal margin.
 */
- (void)setHorizontalMargin:(CGFloat)margin;


@end


NS_ASSUME_NONNULL_END
