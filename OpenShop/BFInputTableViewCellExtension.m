//
//  BFInputTableViewCellExtension.m
//  OpenShop
//
//  Created by Petr Škorňok on 21.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFInputTableViewCellExtension.h"

@implementation BFInputTableViewCellExtension

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController inputAccessoryView:(UIView *)inputAccessoryView {
    self = [super initWithTableViewController:tableViewController];
    if (self) {
        self.inputAccessoryView = inputAccessoryView;
    }
    return self;
}

@end
