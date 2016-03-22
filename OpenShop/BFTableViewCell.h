//
//  BFTableViewCell.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAppAppearance.h"
#import "MGSwipeTableCell+BFNSwipeGestureTutorial.h"
#import "BFNCheckmarkView.h"
#import "BFButton.h"

/**
 * `BFTableViewCell` is a base table view cell wrapper to be subclassed for further use
 * if needed. It contains basic table view cell properties and it manages their appearance
 * according the requirements. It is a subclass of `MGSwipeTableCell` which supports swipe
 * gestures on the table view cell.
 */
@interface BFTableViewCell : MGSwipeTableCell <BFCustomAppearance>

/**
 * Header text label.
 */
@property (nonatomic, weak) IBOutlet UILabel *headerlabel;
/**
 * Subheader text label.
 */
@property (nonatomic, weak) IBOutlet UILabel *subheaderLabel;
/**
 * Description text label.
 */
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
/**
 * Image content view.
 */
@property (nonatomic, weak) IBOutlet UIImageView *imageContentView;
/**
 * Minor text label.
 */
@property (nonatomic, weak) IBOutlet UILabel *detailAccesoryLabel;
/**
 * Minor image content view.
 */
@property (nonatomic, weak) IBOutlet UIImageView *detailAccesoryImage;
/**
 * Action button.
 */
@property (nonatomic, weak) IBOutlet BFButton *actionButton;
/**
 * Action button block callback.
 */
@property (nonatomic, copy) void (^actionButtonBlock)(void);
/**
 *  Checkmark view indicating row selection.
 */
@property (nonatomic, weak) IBOutlet BFNCheckmarkView *checkmark;

/**
 * Selection layer background color.
 */
@property (nonatomic, strong) IBInspectable UIColor *selectionColor;
/**
 * Cell selection is automatically managed with selection layer.
 */
@property (nonatomic, assign) IBInspectable BOOL managesSelection;



@end
