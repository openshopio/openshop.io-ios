//
//  BFSeparatorTableViewCell.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFSeparatorTableViewCell.h"

@implementation BFSeparatorTableViewCell


#pragma mark - Highlight State

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    // notify separators that view is being unhighlighted
    if (!highlighted){
        [self.topSeparatorLine setUnhighlighting:true];
        [self.bottomSeparatorLine setUnhighlighting:true];
    }
}

@end
