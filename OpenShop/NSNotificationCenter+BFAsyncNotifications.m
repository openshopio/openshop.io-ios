//
//  NSNotificationCenter+BFAsyncNotifications.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "NSNotificationCenter+BFAsyncNotifications.h"
@import ObjectiveC.runtime;


@implementation NSNotificationCenter (BFAsyncNotifications)


#pragma mark - Asynchronous Notifications

- (void)BFN_postAsyncNotification:(NSNotification *)notification coalescing:(NSNotificationCoalescing)coalescing whenIdle:(BOOL)idle {
    [[NSNotificationQueue defaultQueue]
     enqueueNotification:notification
     postingStyle:idle ? NSPostWhenIdle : NSPostASAP
     coalesceMask:coalescing
     forModes:@[NSDefaultRunLoopMode]];
}

- (void)BFN_postAsyncNotification:(NSNotification *)notification {
    [self BFN_postAsyncNotification:notification
                     coalescing:(NSNotificationCoalescing)(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                       whenIdle:false];
}

- (void)BFN_postAsyncNotificationName:(NSString *)aName object:(id)anObject {
    [self BFN_postAsyncNotification:[NSNotification notificationWithName:aName object:anObject]
                     coalescing:(NSNotificationCoalescing)(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                       whenIdle:false];
}

- (void)BFN_postAsyncNotificationName:(NSString *)aName object:(id)anObject coalescing:(NSNotificationCoalescing)coalescing whenIdle:(BOOL)idle {
    [self BFN_postAsyncNotification:[NSNotification notificationWithName:aName object:anObject]
                     coalescing:coalescing
                       whenIdle:idle];
}

- (void)BFN_postAsyncNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo {
    [self BFN_postAsyncNotification:[NSNotification notificationWithName:aName object:anObject userInfo:aUserInfo]
                     coalescing:(NSNotificationCoalescing)(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                       whenIdle:false];
}

- (void)BFN_postAsyncNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo coalescing:(NSNotificationCoalescing)coalescing whenIdle:(BOOL)idle {
    [self BFN_postAsyncNotification:[NSNotification notificationWithName:aName object:anObject userInfo:aUserInfo]
                     coalescing:coalescing
                       whenIdle:idle];
}

- (void)BFN_postAsyncNotificationName:(NSString *)aName {
    [self BFN_postAsyncNotification:[NSNotification notificationWithName:aName object:nil]
                     coalescing:(NSNotificationCoalescing)(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                       whenIdle:false];
}


@end
