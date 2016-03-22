//
//  BFSeparatorTableViewCell.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

#import "BFSeparatorLine.h"
#import "BFTableViewCell.h"

/**
 * `BFNCheckmarkTableViewCell` class extends the base table view cell with separator
 * lines displayed according to the cell selection and highlighting.
 */
@interface BFSeparatorTableViewCell : BFTableViewCell

/**
 *  Bottom horizontal separator line.
 */
@property (weak, nonatomic) IBOutlet BFSeparatorLine *bottomSeparatorLine;
/**
 *  Top horizontal separator line.
 */
@property (weak, nonatomic) IBOutlet BFSeparatorLine *topSeparatorLine;


@end
