//
//  UINavigationController+BFCustomTitleView.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "UINavigationController+BFCustomTitleView.h"
#import "UIFont+BFFont.h"
#import "UIColor+BFColor.h"


@implementation UINavigationController (BFCustomTitleView)


#pragma mark - Custom Title View

- (void)setCustomTitleViewText:(NSString *)text {
    // title view appearance
    UIFont *font = [[[UINavigationBar appearance]titleTextAttributes]objectForKey:NSFontAttributeName];
    if(!font) {
        font = [UIFont BFN_robotoMediumWithSize:15];
    }
    UIColor *color = [[[UINavigationBar appearance]titleTextAttributes]objectForKey:NSForegroundColorAttributeName];
    if(!color) {
        color = [UIColor blackColor];
    }
    // set title view
    [self setCustomTitleViewInternalText:text withFont:font color:color];
}

- (void)setCustomTitleViewText:(NSString *)text withFont:(UIFont *)font color:(UIColor *)color {
    // set title view
    [self setCustomTitleViewInternalText:text withFont:font color:color];
}

- (void)setCustomTitleViewInternalText:(id)text withFont:(UIFont *)font color:(UIColor *)color {
    // navigation bar size
    CGFloat navBarHeight = self.navigationBar.frame.size.height;
    CGFloat navBarWidth = self.navigationBar.frame.size.width;
    // custom wrapping title view
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
    // custom title view content
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    // title view font
    if(font) {
        titleLabel.font = font;
    }
    // title view text color
    if(color) {
        titleLabel.textColor = color;
    }
    
    // Set the width of the views according to the text size
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineHeightMultiple = 1.2;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = NSTextAlignmentCenter;
    
    // title view width calculation
    CGFloat desiredWidth;
    if([text isKindOfClass:[NSAttributedString class]]) {
        desiredWidth = [text boundingRectWithSize:CGSizeMake(navBarWidth, navBarHeight) options:NSStringDrawingUsesFontLeading context:nil].size.width;
    }
    else {
        desiredWidth = [text boundingRectWithSize:CGSizeMake(navBarWidth, navBarHeight) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : titleLabel.font, NSParagraphStyleAttributeName : style} context:nil].size.width;
    }
    
    // title view frame
    CGRect titleViewFrame = ({
        CGRect frame = titleLabel.frame;
        frame.size = CGSizeMake(desiredWidth, navBarHeight);
        frame;
    });
    titleLabel.frame = titleViewFrame;
    titleView.frame = titleViewFrame;
    
    // title view text attributes
    titleLabel.numberOfLines = 1;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if([text isKindOfClass:[NSAttributedString class]]) {
        titleLabel.attributedText = text;
    }
    else {
        titleLabel.text = text;
    }
    
    // autoresizing to restrict the bounds to the area that the custom title view allows
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    titleView.autoresizesSubviews = YES;
    titleLabel.autoresizingMask = titleView.autoresizingMask;
    
    // set the custom nav bar titleview
    [titleView addSubview:titleLabel];
    self.visibleViewController.navigationItem.titleView = titleView;
}

- (void)setCustomTitleViewAttributedText:(NSAttributedString *)attributedText {
    // set title view
    [self setCustomTitleViewInternalText:attributedText withFont:nil color:nil];
}

- (void)setCustomTitleViewImage:(UIImage *)image {
    // custom wrapping title view
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
    // custom title view content
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    
    // wrapping title view frame
    titleView.frame = imageView.frame;
    
    // set the custom nav bar titleview
    [titleView addSubview:imageView];
    self.visibleViewController.navigationItem.titleView = titleView;
}





@end
