//
//  NSNumber+BFNSelection.h
//  OpenShop
//
//  Created by Petr Škorňok on 23.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import Foundation;

#import "BFNSelection.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFNSelection` category of NSNumber adds ability to be used as the selection data source item.
 * It implements the `BFNSelection` protocol specifying required methods during the selection process.
 */
@interface NSNumber (BFNSelection) <BFNSelection>

@end

NS_ASSUME_NONNULL_END
