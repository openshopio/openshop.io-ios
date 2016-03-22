//
//  BFProduct.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProduct.h"
#import "BFProductVariant.h"
#import "UIColor+BFColor.h"



/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFProductCategoryIDPropertyName             = @"categoryID";
static NSString *const BFProductBrandIDPropertyName                = @"brand";
static NSString *const BFProductCurrencyIDPropertyName             = @"currency";
static NSString *const BFProductDiscountPricePropertyName          = @"discountPrice";
static NSString *const BFProductDiscountPriceFormattedPropertyName = @"discountPriceFormatted";
static NSString *const BFProductImageURLPropertyName               = @"imageURL";
static NSString *const BFProductImageURLHighResPropertyName        = @"imageURLHighRes";
static NSString *const BFProductNamePropertyName                   = @"name";
static NSString *const BFProductPricePropertyName                  = @"price";
static NSString *const BFProductPriceFormattedPropertyName         = @"priceFormatted";
static NSString *const BFProductProductDescriptionPropertyName     = @"productDescription";
static NSString *const BFProductProductIDPropertyName              = @"productID";
static NSString *const BFProductProductURLPropertyName             = @"productURL";
static NSString *const BFProductRemoteIDPropertyName               = @"remoteID";

/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFProductCategoryIDPropertyJSONMapping             = @"category";
static NSString *const BFProductBrandIDPropertyJSONMapping                = @"brand";
static NSString *const BFProductCurrencyIDPropertyJSONMapping             = @"currency";
static NSString *const BFProductDiscountPricePropertyJSONMapping          = @"discount_price";
static NSString *const BFProductDiscountPriceFormattedPropertyJSONMapping = @"discount_price_formatted";
static NSString *const BFProductImageURLPropertyJSONMapping               = @"main_image";
static NSString *const BFProductImageURLHighResPropertyJSONMapping        = @"main_image_high_res";
static NSString *const BFProductNamePropertyJSONMapping                   = @"name";
static NSString *const BFProductPricePropertyJSONMapping                  = @"price";
static NSString *const BFProductPriceFormattedPropertyJSONMapping         = @"price_formatted";
static NSString *const BFProductProductDescriptionPropertyJSONMapping     = @"description";
static NSString *const BFProductProductIDPropertyJSONMapping              = @"product_id";
static NSString *const BFProductProductURLPropertyJSONMapping             = @"url";
static NSString *const BFProductRemoteIDPropertyJSONMapping               = @"remote_id";



@implementation BFProduct


#pragma mark - MMRecord Location & Options

+ (NSString *)keyPathForResponseObject {
    return nil;
}

+ (NSString *)keyPathForCollectionResponseObject {
    return @"records";
}

+ (MMRecordOptions *)defaultOptions {
    // record options
    MMRecordOptions* opt = [super defaultOptions];
    // delete all orphans
    opt.deleteOrphanedRecordBlock = ^(MMRecord *orphan,
                                      NSArray *populatedRecords,
                                      id responseObject,
                                      BOOL *stop) {
        return NO;
    };
    opt.keyPathForResponseObject = [self keyPathForResponseObject];
    
    return opt;
}

+ (MMRecordOptions *)collectionOptions {
    // record options
    MMRecordOptions* opt = [self defaultOptions];
    // collection response key path
    opt.keyPathForResponseObject = [self keyPathForCollectionResponseObject];
    opt.deleteOrphanedRecordBlock = ^(MMRecord *orphan,
                                      NSArray *populatedRecords,
                                      id responseObject,
                                      BOOL *stop) {
        // remove just orphans matching the populated records
        if([orphan isKindOfClass:[BFProduct class]]) {
            NSPredicate *orphansPredicate = [NSPredicate predicateWithFormat:@"productID == %@", ((BFProduct *)orphan).productID];
            return (BOOL)([[populatedRecords filteredArrayUsingPredicate:orphansPredicate] count]);
        }
        
        return NO;
    };
    return opt;
}



#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFProductCategoryIDPropertyName             : BFProductCategoryIDPropertyJSONMapping,
             BFProductBrandIDPropertyName                : BFProductBrandIDPropertyJSONMapping,
             BFProductCurrencyIDPropertyName             : BFProductCurrencyIDPropertyJSONMapping,
             BFProductDiscountPricePropertyName          : BFProductDiscountPricePropertyJSONMapping,
             BFProductDiscountPriceFormattedPropertyName : BFProductDiscountPriceFormattedPropertyJSONMapping,
             BFProductImageURLPropertyName               : BFProductImageURLPropertyJSONMapping,
             BFProductImageURLHighResPropertyName        : BFProductImageURLHighResPropertyJSONMapping,
             BFProductNamePropertyName                   : BFProductNamePropertyJSONMapping,
             BFProductPricePropertyName                  : BFProductPricePropertyJSONMapping,
             BFProductPriceFormattedPropertyName         : BFProductPriceFormattedPropertyJSONMapping,
             BFProductProductDescriptionPropertyName     : BFProductProductDescriptionPropertyJSONMapping,
             BFProductProductIDPropertyName              : BFProductProductIDPropertyJSONMapping,
             BFProductProductURLPropertyName             : BFProductProductURLPropertyJSONMapping,
             BFProductRemoteIDPropertyName               : BFProductRemoteIDPropertyJSONMapping,
             };
}


#pragma mark - Properties

- (NSMutableAttributedString *)appendPercentageToPriceString:(NSMutableAttributedString *)priceAttributedString {
    // append space
    NSAttributedString *spaceAttributedString = [[NSAttributedString alloc] initWithString:@" "];
    [priceAttributedString appendAttributedString:spaceAttributedString];
    // discount percentage
    CGFloat discountPercent = (1.0-(self.discountPrice.floatValue/self.price.floatValue))*100;
    // \u00A0 represents non-break space
    NSString *discountPercentString = [NSString stringWithFormat:@"\u00A0-%.0f%%\u00A0", discountPercent];
    // discount percent attributed string
    NSAttributedString *discountPercentAttributedString = [[NSAttributedString alloc] initWithString:discountPercentString
                                                                                          attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                       NSBackgroundColorAttributeName: [UIColor BFN_pinkColor]}];
    // append discount percent
    [priceAttributedString appendAttributedString:discountPercentAttributedString];
    return priceAttributedString;
}

- (NSAttributedString *)priceAndDiscountFormattedWithPercentage:(BOOL)percentage {
    // discount price available
    if (self.priceFormatted && self.discountPriceFormatted && ![self.discountPriceFormatted isEqualToString:(NSString *)self.priceFormatted]) {
        // price string
        NSString *priceString = [NSString stringWithFormat:@"%@ %@", self.priceFormatted, self.discountPriceFormatted];
        // price string attributes
        NSMutableAttributedString *priceAttributedString = [[NSMutableAttributedString alloc] initWithString:priceString];
        // original price
        [priceAttributedString addAttributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
                                               NSForegroundColorAttributeName: [UIColor lightGrayColor]}
                                       range: NSMakeRange(0, self.priceFormatted.length)];
        // discount price
        [priceAttributedString addAttributes:@{NSForegroundColorAttributeName: [UIColor BFN_pinkColor]}
                                       range:NSMakeRange(self.priceFormatted.length+1, self.discountPriceFormatted.length)];
        if (percentage) {
            // discount percentage
            priceAttributedString = [self appendPercentageToPriceString:priceAttributedString];
        }
        
        return priceAttributedString;
    }
    else {
        NSString *priceString = self.priceFormatted ?: @"";
        NSAttributedString *priceAttributedString = [[NSAttributedString alloc] initWithString:priceString
                                                                                    attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
        return priceAttributedString;
    }
}


@end
