//
//  BFShareTextProvider.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFShareTextProvider.h"


@implementation BFShareTextProvider


#pragma mark - Initialization

- (instancetype)initWithPlaceholderText:(NSString *)placeholder facebook:(NSString *)fbText twitter:(NSString *)twitterText {
    self = [super initWithPlaceholderItem:placeholder];
    if (self) {
        self.fbText = fbText;
        self.twitterText = twitterText;
        self.placeholder = placeholder;
    }
    return self;
}


#pragma mark - Activity Data Item

- (id)item {
    if ([self.activityType isEqualToString:UIActivityTypePostToFacebook]) {
        return self.fbText;
    }
    else if ([self.activityType isEqualToString:UIActivityTypePostToTwitter]) {
        return self.twitterText;
    }

    return self.placeholder;
}

@end


