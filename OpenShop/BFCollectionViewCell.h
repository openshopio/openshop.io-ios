//
//  BFCollectionViewCell.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFAppAppearance.h"
#import "BFProductImageView.h"

/**
 * `BFCollectionViewCell` is a base collection view cell wrapper to be subclassed for further use
 * if needed. It contains basic collection view cell properties and it manages their appearance
 * according the requirements.
 */
@interface BFCollectionViewCell : UICollectionViewCell <BFCustomAppearance>

/**
 * Header text label.
 */
@property (nonatomic, weak) IBOutlet UILabel *headerlabel;
/**
 * Subheader text label.
 */
@property (nonatomic, weak) IBOutlet UILabel *subheaderLabel;
/**
 * Image content view.
 */
@property (nonatomic, weak) IBOutlet BFProductImageView *imageContentView;


@end
