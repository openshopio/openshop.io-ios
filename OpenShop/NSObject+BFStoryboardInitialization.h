//
//  NSObject+BFStoryboardInitization.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFStoryboardInitization` category of NSObject extends object's capability to fetch
 * storyboard classes (view controllers). The storyboard object can be found by its identifier
 * or by its class name if the class is unique in the whole storyboard.
 */
@interface NSObject (BFStoryboardInitization)


#pragma mark - Storyboard Fetching

/**
 * Returns view controller class instance identified by its class.
 *
 * @param cls The view controller class.
 * @return The view controller instance.
 */
- (nullable UIViewController *)BFN_mainStoryboardClassInstanceWithClass:(Class)cls;
/**
 * Returns view controller class instance specified with unique identifier.
 *
 * @param identifier The view controller unique identifier.
 * @return The view controller instance.
 */
- (nullable UIViewController *)BFN_mainStoryboardClassInstanceWithIdentifier:(NSString *)identifier;
/**
 * Returns view controller class instance identified by its class in storyboard matching given name.
 *
 * @param storyboardName The storyboard name.
 * @param cls The view controller class.
 * @return The view controller instance.
 */
- (nullable UIViewController *)BFN_storyboardNamed:(NSString *)storyboardName classInstanceWithClass:(Class)cls;
/**
 * Returns view controller class instance specified with unique identifier in storyboard matching given name.
 *
 * @param storyboardName The storyboard name.
 * @param identifier The view controller unique identifier.
 * @return The view controller instance.
 */
- (nullable UIViewController *)BFN_storyboardNamed:(NSString *)storyboardName classInstanceWithIdentifier:(NSString *)identifier;


@end

NS_ASSUME_NONNULL_END
