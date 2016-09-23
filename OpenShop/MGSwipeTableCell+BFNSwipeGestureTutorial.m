//
//  MGSwipeTableCell+BFNSwipeGestureTutorial.m
//  OpenShop
//
//  Created by Petr Škorňok on 04.11.15.
//  Copyright © 2015 Business-Factory. All rights reserved.
//

#import "MGSwipeTableCell+BFNSwipeGestureTutorial.h"

@implementation MGSwipeTableCell (BFNSwipeGestureTutorial)

- (void)swipeWithOffset:(CGFloat)offset duration:(CGFloat)duration delay:(CGFloat)delay
{
    __weak MGSwipeTableCell *weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        MGSwipeAnimation *swipeAnimation = [[MGSwipeAnimation alloc] init];
        swipeAnimation.duration = duration;
        [self showSwipe:MGSwipeDirectionRightToLeft animated:YES completion:nil];
        [self setSwipeOffset:offset animation:swipeAnimation completion:^(BOOL completed){
            if (completed) {
                [weakSelf setSwipeOffset:0.0 animation:swipeAnimation completion:nil];
            }
        }];
    });
}
@end
