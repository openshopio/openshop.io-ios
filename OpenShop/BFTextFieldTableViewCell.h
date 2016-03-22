//
//  BFTextFieldTableViewCell.h
//  OpenShop
//
//  Created by Petr Škorňok on 19.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFTableViewCell.h"

/**
 * `BFTextFieldTableViewCell` adds multiple text fields for user input
 * within single table view cell.
 */
@interface BFTextFieldTableViewCell : BFTableViewCell

/**
 * Main text field.
 */
@property (nonatomic, weak) IBOutlet UITextField *mainTextField;
/**
 * Main label to corresponding text field.
 */
@property (nonatomic, weak) IBOutlet UILabel *mainLabel;
/**
 * Additional text field.
 */
@property (nonatomic, weak) IBOutlet UITextField *additionalTextField;
/**
 * Additional label to corresponding text field.
 */
@property (nonatomic, weak) IBOutlet UILabel *additionalLabel;

@end
