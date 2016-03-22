//
//  BFInputTableViewCellExtension.h
//  OpenShop
//
//  Created by Petr Škorňok on 21.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFBaseTableViewCellExtension.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFBaseTableViewCellExtension` is the base table view cell extension. It contains
 * basic properties and initialization methods used by all descendants.
 */
@interface BFInputTableViewCellExtension : BFBaseTableViewCellExtension

/**
 * Accessory view for keyboard.
 */
@property (nonatomic, strong) UIView *inputAccessoryView;

/**
 * Init extension with tableViewController and inputAccessoryView.
 */
- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController
                         inputAccessoryView:(UIView *)inputAccessoryView;

@end

NS_ASSUME_NONNULL_END
