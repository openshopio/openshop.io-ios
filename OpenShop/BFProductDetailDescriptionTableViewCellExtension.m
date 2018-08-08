//
//  BFProductDetailDescriptionTableViewCellExtension.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductDetailDescriptionTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTableViewController.h"
#import "UIColor+BFColor.h"
#import <DTCoreText.h>
#import <DTTiledLayerWithoutFade.h>
#import "BFProductDetailViewController.h"

/**
 * Product description empty header view height.
 */
static CGFloat const productDetailEmptyHeaderFooterViewHeight      = 2.0;
/**
 * Product description table view cell reuse identifier.
 */
static NSString *const productDetailDescriptionCellReuseIdentifier = @"BFProductDetailDescriptionTableViewCellIdentifier";
/**
 * Product description text view margins.
 */
static CGFloat const productDetailDescriptionTextViewMarginTop     = 20.0;
static CGFloat const productDetailDescriptionTextViewMarginLeft    = 20.0;
static CGFloat const productDetailDescriptionTextViewMarginRight   = 20.0;
static CGFloat const productDetailDescriptionTextViewMarginBottom  = 20.0;



@interface BFProductDetailDescriptionTableViewCellExtension ()


@end


@implementation BFProductDetailDescriptionTableViewCellExtension


#pragma mark - Initialization

- (void)didLoad {
    // ensure the text content views draw asynchronously for very long text
    [DTAttributedTextContentView setLayerClass:[DTTiledLayerWithoutFade class]];
}


#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return self.finishedLoading ? 1 : 0;
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    DTAttributedTextCell *cell = (DTAttributedTextCell *)[self preparedCellForIndex:index];
    return [cell requiredRowHeightInTableView:self.tableView];
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    return (DTAttributedTextCell *)[self preparedCellForIndex:index];
}


- (DTAttributedTextCell *)preparedCellForIndex:(NSUInteger)index {
    DTAttributedTextCell *cell = [[DTAttributedTextCell alloc] initWithReuseIdentifier:productDetailDescriptionCellReuseIdentifier];
    // cell style
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // text cell attributes
    cell.attributedTextContextView.backgroundColor = [UIColor clearColor];
    cell.attributedTextContextView.shouldDrawLinks = YES;
    cell.attributedTextContextView.shouldDrawImages = YES;
    cell.attributedTextContextView.delegate = self;
    cell.attributedTextContextView.edgeInsets = UIEdgeInsetsMake(productDetailDescriptionTextViewMarginTop, productDetailDescriptionTextViewMarginLeft, productDetailDescriptionTextViewMarginBottom, productDetailDescriptionTextViewMarginRight);
    
    NSString *productDescription = (self.product && self.product.productDescription) ? [[NSString alloc] initWithString:(NSString *)self.product.productDescription] : @"";
    // text drawing options
    NSDictionary* options = @ {
        @"DTDefaultFontSize": @15,
        @"DTDefaultFontFamily": @"Roboto",
        @"DTDefaultTextColor" : [UIColor darkGrayColor]
    };
    // product desription text
    [cell setHTMLString:productDescription options:options];
    // remove all iframes
    [self removeIframeContent:cell];
    
    return cell;
}

- (void)removeIframeContent:(DTAttributedTextCell *)cell {
    // remove iframe
    NSMutableAttributedString *noIframeAttributedString = [cell.attributedTextContextView.attributedString mutableCopy];
    [noIframeAttributedString beginEditing];
    [noIframeAttributedString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, noIframeAttributedString.length) options:(NSAttributedStringEnumerationOptions)0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if ([value isKindOfClass:[DTIframeTextAttachment class]]) {
            DTIframeTextAttachment *iframeAttachment = (DTIframeTextAttachment *)value;
            iframeAttachment.displaySize = CGSizeZero;
        }
    }];
    [noIframeAttributedString endEditing];
    cell.attributedTextContextView.attributedString = noIframeAttributedString;
}


- (void)didSelectRowAtIndex:(NSInteger)index {
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}


#pragma mark - UITableViewDelegate

- (CGFloat)getHeaderHeight {
    // to prevent grouped table view return the default value
    return productDetailEmptyHeaderFooterViewHeight;
}



@end
