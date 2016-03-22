//
//  BFCartPayment.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCartPayment.h"
#import "BFCartDelivery.h"

@implementation BFCartPayment

- (NSString *)description {
    return [NSString stringWithFormat: @"BFCartPayment: Name = %@ ID = %@", self.name, self.paymentID];
}

@end
