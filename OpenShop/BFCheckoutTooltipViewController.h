//
//  BFCheckoutTooltipViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFFormSheetViewController.h"
#import "BFTooltipView.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * `BFCheckoutTooltipViewController` manages the tooltip view displaying. The tooltip is
 * displayed as the form sheet.
 */
@interface BFCheckoutTooltipViewController : BFFormSheetViewController

/**
 * The tooltip view.
 */
@property (nonatomic, weak) IBOutlet BFTooltipView *tooltip;
/**
 * Tooltip clicked callback.
 */
@property (nonatomic, strong) void (^tooltipTappedHandler)(void);

@end

NS_ASSUME_NONNULL_END
