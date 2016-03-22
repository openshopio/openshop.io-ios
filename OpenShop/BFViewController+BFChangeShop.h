//
//  BFViewController+BFChangeShop.h
//  OpenShop
//
//  Created by Petr Škorňok on 13.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFViewController.h"

@interface BFViewController (BFChangeShop)

- (void)selectShop:(NSNumber *)shopLanguage completion:(void(^)())completionBlock;

@end
