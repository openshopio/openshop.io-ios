//
//  BFOrderFormAdressSingleTableViewCellExtension.h
//  OpenShop
//
//  Created by Petr Škorňok on 19.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFInputTableViewCellExtension.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFAdressSingleTableViewCellExtension` manages single input for address in OrderForm.
 */
@interface BFAddressTableViewCellExtension : BFInputTableViewCellExtension <UITextFieldDelegate>

@end

NS_ASSUME_NONNULL_END