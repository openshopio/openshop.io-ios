//
//  BFShop+BFNSelection.h
//  OpenShop
//
//  Created by Petr Škorňok on 05.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFShop.h"
#import "BFNSelection.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFNSelection` category of BFShop adds ability to be used as the selection data source item.
 * It implements the `BFNSelection` protocol specifying required methods during the selection process.
 */
@interface BFShop (BFNSelection) <BFNSelection>

@end

NS_ASSUME_NONNULL_END
