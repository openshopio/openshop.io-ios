//
//  NSNotificationCenter+BFAsyncNotifications.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN


/**
 * `BFAsyncNotifications` is a category that extends NSNotificationCenter to make usage of asynchronous
 * notifications simple. It is intended to help with notification creation, its asynchronous posting and
 * optional coalescing.
 */
@interface NSNotificationCenter (BFAsyncNotifications)

/**
 * Posts a notification to the receiver asynchronously.
 *
 * @param notification The notification object.
 */
- (void)BFN_postAsyncNotification:(NSNotification *)notification;

/**
 * Posts a notification with a specified coalescing information to the receiver asynchronously.
 *
 * @param notification The notification object.
 * @param coalescing Notification coalescing. Coalescing is allowed on name, on sender,
 *                   combination of both or it can be disabled.
 * @param idle If set to TRUE, notification is posted when the run loop is idle.
 */
- (void)BFN_postAsyncNotification:(NSNotification *)notification coalescing:(NSNotificationCoalescing)coalescing whenIdle:(BOOL)idle;

/**
 * Creates a notification with a specified name and posts it to the receiver asynchronously.
 *
 * @param aName The name of the notification.
 */
- (void)BFN_postAsyncNotificationName:(NSString *)aName;

/**
 * Creates a notification with a specified name, sender and posts it to the receiver asynchronously.
 *
 * @param aName The name of the notification.
 * @param anObject The object posting the notification.
 */
- (void)BFN_postAsyncNotificationName:(NSString *)aName object:(nullable id)anObject;

/**
 * Creates a notification with a specified name, sender, coalescing information and posts it to the receiver asynchronously.
 *
 * @param aName The name of the notification.
 * @param anObject The object posting the notification.
 * @param coalescing Notification coalescing. Coalescing is allowed on name, on sender,
 *                   combination of both or it can be disabled.
 * @param idle If set to TRUE, notification is posted when the run loop is idle.
 */
- (void)BFN_postAsyncNotificationName:(NSString *)aName object:(nullable id)anObject coalescing:(NSNotificationCoalescing)coalescing whenIdle:(BOOL)idle;

/**
 * Creates a notification with a specified name, sender, user information and posts it to the receiver asynchronously.
 *
 * @param aName The name of the notification.
 * @param anObject The object posting the notification.
 * @param aUserInfo Information about the the notification. May be nil.
 */
- (void)BFN_postAsyncNotificationName:(NSString *)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;

/**
 * Creates a notification with a specified name, sender, user information, coalescing information and posts it to the receiver asynchronously.
 *
 * @param aName The name of the notification.
 * @param anObject The object posting the notification.
 * @param aUserInfo Information about the the notification. May be nil.
 * @param coalescing Notification coalescing. Coalescing is allowed on name, on sender,
 *                   combination of both or it can be disabled.
 * @param idle If set to TRUE, notification is posted when the run loop is idle.
 */
- (void)BFN_postAsyncNotificationName:(NSString *)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo coalescing:(NSNotificationCoalescing)coalescing whenIdle:(BOOL)idle;

@end

NS_ASSUME_NONNULL_END
