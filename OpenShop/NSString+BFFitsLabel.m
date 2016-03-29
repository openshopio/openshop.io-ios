//
//  NSString+BFFitsLabel.m
//  OpenShop
//
//  Created by Petr Škorňok on 28.03.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "NSString+BFFitsLabel.h"

@implementation NSString (BFFitsLabel)

- (BOOL)fitsLabel:(UILabel *)label {
    NSString *string = self;
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: label.font}];
    return label.frame.size.width >= size.width;
}

@end
