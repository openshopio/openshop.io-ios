//
//  BFTextFieldTableViewCell.m
//  OpenShop
//
//  Created by Petr Škorňok on 19.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFTextFieldTableViewCell.h"

@implementation BFTextFieldTableViewCell

- (void)prepareForReuse
{
    self.mainLabel.text = nil;
    self.mainTextField.text = nil;
    self.additionalLabel.text = nil;
    self.additionalTextField.text = nil;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [self.mainTextField becomeFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
