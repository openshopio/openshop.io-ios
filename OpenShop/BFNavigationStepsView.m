//
//  BFNavigationStepsView.m
//  OpenShop
//
//  Created by Petr Škorňok on 18.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFNavigationStepsView.h"
#import "UIFont+BFFont.h"
#import "UIColor+BFColor.h"

@interface BFNavigationStepsView ()



@end

@implementation BFNavigationStepsView

- (instancetype)init {
    if ((self = [super init])) {
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect myframe = self.frame;
    UIFont *selectedFont = [UIFont BFN_robotoMediumWithSize: 12];
    UIFont *unselectedFont = [UIFont BFN_robotoMediumWithSize: 12];

    UIColor *selectedFontColor = UIColor.whiteColor;
    UIColor *unselectedFontColor = UIColor.grayColor;

    UIColor *selectedFrameBackgroundColor = [UIColor BFN_pinkColor];
    UIColor *unselectedFrameBackgroundColor = [UIColor whiteColor];
    
    CGFloat offset = 10.0f;
    
    CGFloat frameWidth = CGRectGetWidth(myframe);
    CGFloat frameHeight = CGRectGetHeight(myframe);
    CGFloat minX = CGRectGetMinX(myframe);
    CGFloat minY = CGRectGetMinY(myframe);
    CGFloat maxX = minX + frameWidth;
    CGFloat maxY = minY + frameHeight;
    
    CGFloat firstPartMinTopX = minX;
    CGFloat firstPartMaxTopX = firstPartMinTopX + 0.33833 * frameWidth;
    CGFloat firstPartTopY = minY;
    CGFloat firstPartMinBottomX = minX;
    CGFloat firstPartMaxBottomX = firstPartMinBottomX + 0.33833 * frameWidth + offset;
    CGFloat firstPartBottomY = maxY;

    CGFloat secondPartMinTopX = firstPartMaxTopX;
    CGFloat secondPartMaxTopX = secondPartMinTopX + 0.33833 * frameWidth;
    CGFloat secondPartTopY = minY;
    CGFloat secondPartMinBottomX = firstPartMaxBottomX;
    CGFloat secondPartMaxBottomX = secondPartMinBottomX + 0.33833 * frameWidth;
    CGFloat secondPartBottomY = maxY;

    CGFloat thirdPartMinTopX = secondPartMaxTopX;
    CGFloat thirdPartMaxTopX = maxX;
    CGFloat thirdPartTopY = minY;
    CGFloat thirdPartMinBottomX = secondPartMaxBottomX;
    CGFloat thirdPartMaxBottomX = maxX;
    CGFloat thirdPartBottomY = maxY;

    //// topline
    UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
    [bezier2Path moveToPoint: CGPointMake(minX, minY)];
    [bezier2Path addLineToPoint: CGPointMake(maxX, minY)];
    [UIColor.lightGrayColor setStroke];
    bezier2Path.lineWidth = 1;
    [bezier2Path stroke];
    
    
    //// bottomline
    UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
    [bezier3Path moveToPoint: CGPointMake(minX, maxY)];
    [bezier3Path addLineToPoint: CGPointMake(maxX, maxY)];
    [UIColor.lightGrayColor setStroke];
    bezier3Path.lineWidth = 1;
    [bezier3Path stroke];
    
    //// first part
    UIBezierPath* firstPath = UIBezierPath.bezierPath;
    [firstPath moveToPoint: CGPointMake(firstPartMinTopX, firstPartTopY)];
    [firstPath addLineToPoint: CGPointMake(firstPartMaxTopX, firstPartTopY)];
    [firstPath addLineToPoint: CGPointMake(firstPartMaxBottomX, firstPartBottomY)];
    [firstPath addLineToPoint: CGPointMake(firstPartMinBottomX, firstPartBottomY)];
    [firstPath addLineToPoint: CGPointMake(firstPartMinTopX, firstPartTopY)];
    firstPath.lineWidth = 0.5;
    [firstPath closePath];
    
    
    //// second part
    UIBezierPath* secondPath = UIBezierPath.bezierPath;
    [secondPath moveToPoint: CGPointMake(secondPartMinTopX, secondPartTopY)];
    [secondPath addLineToPoint: CGPointMake(secondPartMaxTopX, secondPartTopY)];
    [secondPath addLineToPoint: CGPointMake(secondPartMaxBottomX, secondPartBottomY)];
    [secondPath addLineToPoint: CGPointMake(secondPartMinBottomX, secondPartBottomY)];
    [secondPath addLineToPoint: CGPointMake(secondPartMinTopX, secondPartTopY)];
    secondPath.lineWidth = 0.5;
    [secondPath closePath];
    [secondPath stroke];
    
    //// third part
    UIBezierPath* thirdPath = UIBezierPath.bezierPath;
    [thirdPath moveToPoint: CGPointMake(thirdPartMinTopX, thirdPartTopY)];
    [thirdPath addLineToPoint: CGPointMake(thirdPartMaxTopX, thirdPartTopY)];
    [thirdPath addLineToPoint: CGPointMake(thirdPartMaxBottomX, thirdPartBottomY)];
    [thirdPath addLineToPoint: CGPointMake(thirdPartMinBottomX, thirdPartBottomY)];
    [thirdPath addLineToPoint: CGPointMake(thirdPartMinTopX, thirdPartTopY)];
    thirdPath.lineWidth = 0.5;
    [thirdPath closePath];
    [thirdPath stroke];

    switch (self.navigationStep) {
        case BFNavigationStepFirst: {
            [UIColor.whiteColor setStroke];
            [selectedFrameBackgroundColor setFill];
            [firstPath fill];
            [firstPath stroke];
            
            [UIColor.grayColor setStroke];
            [[UIColor clearColor] setFill];
            [secondPath fill];
            [secondPath stroke];
            break;
        }
        case BFNavigationStepSecond: {
            [UIColor.whiteColor setStroke];
            [selectedFrameBackgroundColor setFill];
            [firstPath fill];
            [firstPath stroke];
            [secondPath fill];
            [secondPath stroke];
            break;
        }
        case BFNavigationStepThird: {
            [UIColor.whiteColor setStroke];
            [selectedFrameBackgroundColor setFill];
            [firstPath fill];
            [firstPath stroke];
            [secondPath fill];
            [secondPath stroke];
            [thirdPath fill];
            [thirdPath stroke];
            break;
        }

        default:
            break;
    }
    
    //// Text Drawing
    CGRect textRect = CGRectMake(CGRectGetMinX(myframe)+7.5, CGRectGetMinY(myframe), 0.33833 * CGRectGetWidth(myframe), CGRectGetHeight(myframe));
    {
        NSString* textContent = [BFLocalizedString(kTranslationCart, @"Cart") uppercaseString];
        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSTextAlignmentCenter;
        
        UIColor *color;
        UIFont *font;
        switch (self.navigationStep) {
            case BFNavigationStepFirst:
            case BFNavigationStepSecond:
            case BFNavigationStepThird:
                color = selectedFontColor;
                font = selectedFont;
                break;
                
            default:
                color = unselectedFontColor;
                font = unselectedFont;
                break;
        }
        
        NSDictionary* textFontAttributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: textStyle};
        
        CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, textRect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withAttributes: textFontAttributes];
        CGContextRestoreGState(context);
    }
    
    
    //// Text 2 Drawing
    CGRect text2Rect = CGRectMake(CGRectGetMinX(myframe) + 0.33833 * CGRectGetWidth(myframe)+7.5, CGRectGetMinY(myframe), 0.66833 * CGRectGetWidth(myframe) - 0.33833 * CGRectGetWidth(myframe), CGRectGetHeight(myframe));
    {
        NSString* textContent = [BFLocalizedString(kTranslationOrder, @"Order") uppercaseString];
        NSMutableParagraphStyle* text2Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text2Style.alignment = NSTextAlignmentCenter;
        
        UIColor *color;
        UIFont *font;
        switch (self.navigationStep) {
            case BFNavigationStepSecond:
            case BFNavigationStepThird:
                color = selectedFontColor;
                font = selectedFont;
                break;
                
            default:
                color = unselectedFontColor;
                font = unselectedFont;
                break;
        }
        
        NSDictionary* text2FontAttributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: text2Style};
        
        CGFloat text2TextHeight = [textContent boundingRectWithSize: CGSizeMake(text2Rect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: text2FontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, text2Rect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(text2Rect), CGRectGetMinY(text2Rect) + (CGRectGetHeight(text2Rect) - text2TextHeight) / 2, CGRectGetWidth(text2Rect), text2TextHeight) withAttributes: text2FontAttributes];
        CGContextRestoreGState(context);
    }
    
    
    //// Text 3 Drawing
    CGRect text3Rect = CGRectMake(CGRectGetMinX(myframe) + 0.66833 * CGRectGetWidth(myframe)+7.5, CGRectGetMinY(myframe), CGRectGetWidth(myframe) - 0.66833 * CGRectGetWidth(myframe), CGRectGetHeight(myframe));
    {
        NSString* textContent = [BFLocalizedString(kTranslationSummary, @"Summary") uppercaseString];;
        NSMutableParagraphStyle* text3Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text3Style.alignment = NSTextAlignmentCenter;
        
        UIColor *color;
        UIFont *font;
        switch (self.navigationStep) {
            case BFNavigationStepThird:
                color = selectedFontColor;
                font = selectedFont;
                break;
                
            default:
                color = unselectedFontColor;
                font = unselectedFont;
                break;
        }
        
        NSDictionary* text3FontAttributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: text3Style};
        
        CGFloat text3TextHeight = [textContent boundingRectWithSize: CGSizeMake(text3Rect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: text3FontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, text3Rect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(text3Rect), CGRectGetMinY(text3Rect) + (CGRectGetHeight(text3Rect) - text3TextHeight) / 2, CGRectGetWidth(text3Rect), text3TextHeight) withAttributes: text3FontAttributes];
        CGContextRestoreGState(context);
    }
}

@end
