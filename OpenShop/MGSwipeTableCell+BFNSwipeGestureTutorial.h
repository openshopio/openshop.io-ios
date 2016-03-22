//
//  MGSwipeTableCell+BFNSwipeGestureTutorial.h
//  OpenShop
//
//  Created by Petr Škorňok on 04.11.15.
//  Copyright © 2015 Business-Factory. All rights reserved.
//

#import "MGSwipeTableCell.h"

@interface MGSwipeTableCell (BFNSwipeGestureTutorial)

- (void)swipeWithOffset:(CGFloat)offset
               duration:(CGFloat)duration
                  delay:(CGFloat)delay;

@end
