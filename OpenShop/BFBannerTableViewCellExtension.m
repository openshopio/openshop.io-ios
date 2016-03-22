//
//  BFBannerTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFBannerTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewController.h"
#import "UIImage+BFImageResize.h"
#import <UIImageView+AFNetworking.h>
#import "BFBannersViewController.h"
#import "BFProductsViewController.h"
#import "BFProductDetailViewController.h"

/**
 * Banner table view cell reuse identifier.
 */
static NSString *const bannerCellReuseIdentifier        = @"BFBannerTableViewCellIdentifier";
/**
 * Presenting segue product information parameter.
 */
static NSString *const segueParameterProductInfo        = @"productInfo";
/**
 * Banner default height.
 */
static CGFloat const bannerPlaceholderHeight            = 100.0f;
/**
 * Banner bottom padding.
 */
static CGFloat const bannerPadding                      = 10.0f;
/**
 * Banner caching interval (seconds).
 */
static NSTimeInterval const bannerCachingInterval       = 60;


@interface BFBannerTableViewCellExtension ()

/**
 * Banners height cache for dynamic sizing.
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *bannersHeightCache;


@end


@implementation BFBannerTableViewCellExtension


#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super initWithTableViewController:tableViewController];
    if (self) {
        self.banners = @[];
        self.bannersHeightCache = [NSMutableDictionary new];
    }
    return self;
}

- (void)didLoad {
    
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.banners count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    BFBanner *banner = [self.banners objectAtIndex:index];
    NSNumber *bannerCachedHeight;
    
    if(banner && banner.imageURL) {
        NSString *bannerKey = banner.imageURL;
        bannerCachedHeight = [self.bannersHeightCache objectForKey:bannerKey];
    }
    
    return bannerCachedHeight ? [bannerCachedHeight floatValue] + bannerPadding : bannerPlaceholderHeight + bannerPadding;
}

- (CGFloat)getEstimatedHeightForRowAtIndex:(NSUInteger)index {
    return [self getHeightForRowAtIndex:index];
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFTableViewCell *cell = (BFTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:bannerCellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bannerCellReuseIdentifier];
    }
    // banner
    BFBanner *banner = [self.banners objectAtIndex:index];
    NSString *bannerURLString = banner.imageURL;
    NSURL *bannerURL = [NSURL URLWithString:bannerURLString];

    // fetch banner image asynchronously
    if(bannerURL) {
        __weak __typeof__(self) weakSelf = self;
        __weak __typeof__(BFTableViewCell *) weakCell = cell;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:bannerURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:bannerCachingInterval];
        
        [cell.imageContentView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            // scale image to fit
            CGFloat width = weakSelf.tableView.frame.size.width;
            image = [image scaleImageToWidth:width];
            
            NSNumber *bannerCachedHeight = [weakSelf.bannersHeightCache objectForKey:bannerURLString];
            // no cached image height
            if(!bannerCachedHeight) {
                // save height
                [weakSelf.bannersHeightCache setObject:[NSNumber numberWithFloat:image.size.height] forKey:bannerURLString];
                // refresh cell to get the correct height
                [weakSelf.tableView reloadData];
            }
            else {
                // cell is correctly sized, just set the image
                [weakCell.imageContentView setImage:image];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            weakCell.imageContentView.image = nil;
        }];
    }

    return cell;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    BFBanner *banner = [self.banners objectAtIndex:index];
    
    NSArray *linkTypeComponents = [banner.target componentsSeparatedByString:@":"];
    if([linkTypeComponents count] == 2) {
        NSNumber *targetType = [BFAppStructure linkTypeFromAPIName:linkTypeComponents[0]];
        NSString *targetID = linkTypeComponents[1];
        if(targetType) {
            // present products category
            if ([targetType integerValue] == BFLinkTypeDetail) {
                BFDataRequestProductInfo *productInfo = [[BFDataRequestProductInfo alloc]init];
                [productInfo setProductID:@([targetID integerValue])];
                [productInfo setResultsTitle:[banner name]];
                [self.tableViewController performSegueWithViewController:[BFProductDetailViewController class] params:@{ segueParameterProductInfo : productInfo}];
            }
            // present product detail
            else if ([targetType integerValue] == BFLinkTypeList) {
                BFDataRequestProductInfo *productInfo = [[BFDataRequestProductInfo alloc]init];
                [productInfo setCategoryID:@([targetID integerValue])];
                [productInfo setResultsTitle:[banner name]];
                [self.tableViewController performSegueWithViewController:[BFProductsViewController class] params:@{ segueParameterProductInfo : productInfo}];
            }
        }
    }

    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}



@end
