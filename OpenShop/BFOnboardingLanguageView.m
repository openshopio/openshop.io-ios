//
//  BFOnboardingLanguageView.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOnboardingLanguageView.h"


@implementation BFOnboardingLanguageView

- (void)setLanguageCode:(NSString *)languageCode {
    // set app language when IB property changed
    _languageCode = languageCode;
    self.language = (BFLanguage)[[BFAppStructure languageWithCode:_languageCode]integerValue];
}

@end
