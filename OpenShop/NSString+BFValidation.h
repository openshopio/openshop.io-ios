//
//  NSString+BFValidation.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

/**
 * `BFValidation` category of NSString adds possibility to compare the string contents
 * with desired structure template.
 */
@interface NSString (BFValidation)

/**
 * Examines whether the string matches valid email address template.
 * @return TRUE if the string is a valid email address, else FALSE.
 */
- (BOOL)isValidEmail;


@end
