//
//  BFBranchViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import MapKit;
#import "BFFormSheetViewController.h"
#import "BFBranchTransportView.h"


NS_ASSUME_NONNULL_BEGIN

/*
 * The selected shop branch completion block type.
 */
typedef void (^BFSelectedBranchCompletionHandler)(BFBranch *selectedBranch);

/**
 * `BFBranchViewController` displays shop branches information. Each page view represents
 * shop branch information consisting of the branch title, address, opening hours, transport options
 * and a branch location in the map view.
 */
@interface BFBranchViewController : BFFormSheetViewController <MKMapViewDelegate>

/**
 * The shop branches.
 */
@property (nonatomic, strong) NSArray *branches;
/**
 * The currently display shop branch index in the data source.
 */
@property (nonatomic, assign) NSUInteger currentIndex;
/**
 * The shop branch selection handler.
 */
@property (nonatomic, copy) BFSelectedBranchCompletionHandler selectionHandler;
/**
 * The selection button visiblity.
 */
@property (nonatomic, assign) IBInspectable BOOL showsSelectionButton;
/**
 * The close button visiblity.
 */
@property (nonatomic, assign) IBInspectable BOOL showsCloseButton;


@end

NS_ASSUME_NONNULL_END
