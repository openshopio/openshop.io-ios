//
//  UIAlertController+BFShowable.h
//  OpenShop
//
//  Created by Petr Škorňok on 12.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import UIKit;

@interface UIAlertController (BFShowable)

- (void)show;

- (void)presentAnimated:(BOOL)animated
             completion:(void (^)(void))completion;

- (void)presentFromController:(UIViewController *)viewController
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion;

@end
