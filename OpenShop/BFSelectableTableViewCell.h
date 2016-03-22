//
//  BFSelectableTableViewCell.h
//  OpenShop
//
//  Created by Petr Škorňok on 23.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFTableViewCell.h"

/**
 * `BFSelectableTableViewCell` subclasses `BFTableViewCell` in order to
 * provide custom behaviour on setSelected and setHighlighted methods.
 */
@interface BFSelectableTableViewCell : BFTableViewCell

/**
 * Title label to be highlighted.
 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/**
 * Subtitle label to be highlighted.
 */
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
/**
 * Accessory label to be highlighted.
 */
@property (nonatomic, weak) IBOutlet UILabel *accessoryLabel;
/**
 * Vertical view line to be highlighted.
 */
@property (nonatomic, weak) IBOutlet UIView *verticalView;

@end
