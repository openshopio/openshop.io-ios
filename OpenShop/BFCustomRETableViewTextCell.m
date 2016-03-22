//
//  BFCustomRETableViewTextCell.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCustomRETableViewTextCell.h"
#import "UIFont+BFFont.h"


@interface BFCustomRETableViewTextCell ()

@end


@implementation BFCustomRETableViewTextCell


#pragma mark - Appearance Customization

- (void)cellDidLoad {
    [super cellDidLoad];

    if(!_appearanceBlock) {
        _appearanceBlock = ^(RETableViewTextCell *cell) {
            // adjust cell title label and input field appearance
            cell.textLabel.font = [UIFont BFN_robotoMediumWithSize:13];
            cell.textField.font = [UIFont BFN_robotoRegularWithSize:13];
            cell.textField.textColor = [UIColor darkGrayColor];
        };
    }
}

- (void)cellWillAppear {
    [super cellWillAppear];
    
    // apply appearance block
    if(self.appearanceBlock) {
        self.appearanceBlock(self);
    }
}



@end
