//
//  NSNotificationCenter+BFManagedNotificationObserver.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFManagedNotificationObserver` is a category that extends NSNotificationCenter to make usage of notifications
 * simple. It is intended to manage notification observers the way they are automatically removed when the
 * observer is deallocated.
 */
@interface NSNotificationCenter (BFManagedNotificationObserver)



@end

NS_ASSUME_NONNULL_END
