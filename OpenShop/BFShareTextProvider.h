//
//  BFShareTextProvider.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFShareTextProvider` models a proxy for text data passed to an activity view controller.
 */
@interface BFShareTextProvider : UIActivityItemProvider <UIActivityItemSource>

/**
 * The text placeholder string.
 */
@property (nonatomic, strong) NSString *placeholder;
/**
 * The Facebook text.
 */
@property (nonatomic, strong) NSString *fbText;
/**
 * The Twitter text.
 */
@property (nonatomic, strong) NSString *twitterText;

/**
 * Creates the text data provider with placeholder text.
 *
 * @param placeholder The placeholder text.
 * @param fbText The Facebook text.
 * @param twitterText The twitter text.
 * @return The newly-initialized `BFShareTextProvider`.
 */
- (instancetype)initWithPlaceholderText:(NSString *)placeholder facebook:(NSString *)fbText twitter:(NSString *)twitterText;

@end


NS_ASSUME_NONNULL_END