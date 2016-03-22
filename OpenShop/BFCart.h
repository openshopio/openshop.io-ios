//
//  BFCart.h
//  OpenShop
//
//  Created by Petr Škorňok on 30.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "BFRecord.h"

@class BFCartDiscountItem, BFCartProductItem;

NS_ASSUME_NONNULL_BEGIN

@interface BFCart : BFRecord

@end

NS_ASSUME_NONNULL_END

#import "BFCart+CoreDataProperties.h"
