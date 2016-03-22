//
//  BFDataViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAppAppearance.h"
#import "BFViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BFTableViewCellExtension.h"

NS_ASSUME_NONNULL_BEGIN

/**
* `BFDataExtensionDelegate` is a protocol specifying data extension callback methods
* to perform a view controller transition.
*/
@protocol BFDataExtensionDelegate <NSObject>

/**
 * Performs segue to the view controller with optional parameters.
 *
 * @param viewController The destination view controller.
 * @param dictionary The destination view controller parameters.
 */
- (void)performSegueWithViewController:(Class)viewController params:(nullable NSDictionary *)dictionary;

@optional

/**
 * Applies presenting segue parameters to the destination view controller.
 *
 * @param viewController The destination view controller.
 */
- (void)applySegueParameters:(UIViewController *)viewController;

@end


/**
 * `BFDataViewController` is a base view controller to add support for data extensions.
 * Data extensions are used to model a separate unit in the data presentation in the
 * table view or collection view. This controller is also an empty data source and
 * data set delegate which is intended to be fully implemented in the subclass.
 */
@interface BFDataViewController : BFViewController <BFCustomAppearance, BFDataExtensionDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/**
 * Empty data image.
 */
@property (nonatomic, strong, nullable) UIImage *emptyDataImage;
/**
 * Empty data title.
 */
@property (nonatomic, copy, nullable) NSString *emptyDataTitle;
/**
 * Empty data title color.
 */
@property (nonatomic, copy, nullable) UIColor *emptyDataTitleColor;
/**
 * Empty data subtitle.
 */
@property (nonatomic, copy, nullable) NSString *emptyDataSubtitle;
/**
 * Empty data subtitle color.
 */
@property (nonatomic, copy, nullable) UIColor *emptyDataSubtitleColor;
/**
 * Data fetching from the network indicator.
 */
@property (nonatomic, assign) BOOL loadingData;
/**
 * Presenting segue parameters. Used in the view controller transition to customize
 * the destination view controller.
 */
@property (nonatomic, strong) NSDictionary <NSString *, id> *segueParameters;

/**
 * Adds data extension to the data source.
 */
- (void)addExtension:(id <BFDataExtension>)extension;
/**
 * Removes data extension from the data source.
 */
- (void)removeExtension:(id <BFDataExtension>)extension;
/**
 * Removes all data extensions from the data source.
 */
- (void)removeAllExtensions;
/**
 * Sets data extensions.
 */
- (void)setExtensions:(NSArray<id<BFDataExtension>> *)extensions;
/**
 * Returns an index of the data extension in the extensions data source.
 *
 * @return The data extension index.
 */
- (NSUInteger)indexOfExtension:(id<BFDataExtension>)extension;
/**
 * Returns data extension at index in the extensions data source.
 *
 * @return The data extension.
 */
- (id<BFDataExtension>)extensionAtIndex:(NSUInteger)index;
/**
 * Returns number of items in the extensions data source.
 *
 * @return The number of data extensions.
 */
- (NSUInteger)numOfExtensions;
/**
 * Determines if the controller contains the given extension.
 *
 * @return YES if the controller contains the given extension.
 */
- (BOOL)containsExtension:(id<BFDataExtension>)extension;

@end

NS_ASSUME_NONNULL_END


