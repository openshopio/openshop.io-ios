//
//  BFSelectableTableViewCell.m
//  OpenShop
//
//  Created by Petr Škorňok on 23.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFSelectableTableViewCell.h"
#import "UIColor+BFColor.h"

@implementation BFSelectableTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self dimSubviews];
    self.titleLabel.text = nil;
    self.subtitleLabel.text = nil;
    self.accessoryLabel.text = nil;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        [self highlightSubviews];
    }
    else {
        [self dimSubviews];
    }
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        [self highlightSubviews];
    }
    else {
        [self dimSubviews];
    }
    [super setSelected:selected animated:animated];
}

- (void)highlightSubviews {
    self.titleLabel.textColor = [UIColor BFN_pinkColor];
    self.subtitleLabel.textColor = [UIColor BFN_pinkColor];
    self.accessoryLabel.textColor = [UIColor BFN_pinkColor];
    self.verticalView.hidden = NO;
}

- (void)dimSubviews {
    self.titleLabel.textColor = [UIColor blackColor];
    self.subtitleLabel.textColor = [UIColor grayColor];
    self.accessoryLabel.textColor = [UIColor grayColor];
    self.verticalView.hidden = YES;
}

@end
