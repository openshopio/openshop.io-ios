//
//  BFStoryboardNoAnimationSegue.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFStoryboardNoAnimationSegue.h"


@implementation BFStoryboardNoAnimationSegue

- (void)perform {
    // overriden to disable animation
    if([[self sourceViewController] navigationController]) {
        [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
    }
}

@end
