//
//  BFOnboardingLanguageContentViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOnboardingLanguageContentViewController.h"
#import "StorageManager.h"
#import "BFAPIManager.h"
#import "UIFont+BFFont.h"
#import "BFAppPreferences.h"
#import "BFAppSessionInfo.h"
#import "BFActionSheetPicker.h"
#import "BFAlignedImageButton.h"
#import "BFShop.h"
#import "BFShop+BFNSelection.h"
#import "UIWindow+BFOverlays.h"
#import <POP.h>

/**
 * Text label paragraph line spacing.
 */
static NSInteger const textParagraphLineSpacing = 5;
/**
 * Text label paragraph line spacing.
 */
static NSString *const shakeAnimationKey = @"viewShakeAnimationKey";
/**
 * Content height on the first launch.
 */
static CGFloat const contentHeightFirstLaunch = 220.0;
/**
 * Content height on the normal launch.
 */
static CGFloat const contentHeight = 200.0;

@interface BFOnboardingLanguageContentViewController ()

/**
 * Selected language.
 */
@property (nonatomic, strong) BFShop *selectedShop;
/**
 * Flag indicating if the network request is being processed.
 */
@property (nonatomic) BOOL loading;

@end


@implementation BFOnboardingLanguageContentViewController


#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    if ([[BFAppSessionInfo sharedInfo]firstLaunch]) {
        self.contentHeight = contentHeightFirstLaunch;
    }
    else {
        self.contentHeight = contentHeight;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initial load of languages
    [self loadLanguagesFromNetwork];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // subheader
    [self.subheaderLabel setAttributedText:[self subheaderText]];
    [self.selectLanguageButton setTitle:BFLocalizedString(kTranslationCountry, @"Country") forState:UIControlStateNormal];
    [self.continueButton setTitle:[BFLocalizedString(kTranslationContinue, @"Continue") uppercaseString] forState:UIControlStateNormal];
    
}

#pragma mark - Custom getters & setters

- (void)setSelectedShop:(BFShop *)selectedShop {
    _selectedShop = selectedShop;
    [self.selectLanguageButton setTitle:_selectedShop.name forState:UIControlStateNormal];
}

#pragma mark - Translations & Dynamic Content

- (void)loadLanguagesFromNetwork {
    self.loading = YES;
    __weak __typeof(self)weakSelf = self;

    [[BFAPIManager sharedManager] findShopsWithCompletionBlock:^(NSArray * _Nullable records, id  _Nullable customResponse, NSError * _Nullable error) {
        weakSelf.loading = NO;
        if (!error) {
            // set data source
            weakSelf.languageItems = records;
            // preselect first shop
            weakSelf.selectedShop = [records firstObject];
            // dismiss overlays
            [weakSelf.view.window dismissAllOverlaysWithCompletion:^{
                __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf showLanguagesActionSheetPicker:weakSelf.selectLanguageButton];
            } animated:YES];
        }
        else {
            [self.view.window dismissAllOverlaysWithCompletion:^{
                BFError *customError = [BFError errorWithError:error];
                [customError showAlertFromSender:weakSelf];
            } animated:YES];
        }
    }];
}

- (NSAttributedString *)subheaderText {
    // subheader text strings
    NSString *subheaderStringFirst = BFLocalizedString(kTranslationChooseCountry, @"Select a country,");
    NSString *subheaderStringSecond = BFLocalizedString(kTranslationWhereYouWantToShop, @"where you want to shop");
    
    // subheader attributes
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:textParagraphLineSpacing];
    [style setAlignment:NSTextAlignmentCenter];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@", subheaderStringFirst, subheaderStringSecond]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont BFN_robotoMediumWithSize:18] range:NSMakeRange(0, subheaderStringFirst.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont BFN_robotoLightWithSize:14] range:NSMakeRange(subheaderStringFirst.length, labs((NSInteger)attributedString.length-(NSInteger)subheaderStringFirst.length))];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
}


#pragma mark - BFOnboardingContentViewState Protocol

- (void)visibilityChangedWithPercentage:(NSInteger)percentage {
    
}

#pragma mark - Action Sheet Picker

- (IBAction)languageButtonAction:(id)sender {
    // show action sheet picker if the languages are loaded
    if (self.languageItems) {
        [self showLanguagesActionSheetPicker:sender];
    }
    // if the languages are still loading show progress overlay
    else if (self.loading) {
        [self showLoadingOverlay];
    }
    // if the langages are loaded and they are empty than something bad happened
    // maybe the user has lost the internet connection, try to reload data
    // and display loading overlay
    else {
        [self loadLanguagesFromNetwork];
        [self showLoadingOverlay];
    }
}

- (void)showLoadingOverlay {
    [self.view.window showIndeterminateSmallProgressOverlayWithTitle:BFLocalizedString(kTranslationLoading, @"Loading") animated:YES];
}

- (void)showLanguagesActionSheetPicker:(id)sender {
    // initial selection index
    NSUInteger initialSelection = 0;
    if(self.selectedShop && [self.languageItems indexOfObject:self.selectedShop] != NSNotFound) {
        initialSelection = [self.languageItems indexOfObject:self.selectedShop];
    }
    
    // selection completion block
    __weak __typeof(self)weakSelf = self;
    
    BFNActionDoneBlock doneBlock = ^(BFActionSheetPicker *picker, NSInteger selectedIndex, id<BFNSelection> selectedValue) {
        if(selectedValue && [selectedValue isKindOfClass:[BFShop class]]) {
            weakSelf.selectedShop = (BFShop *)selectedValue;
        }
    };
    
    // present selection picker
    [BFActionSheetPicker showPickerWithTitle:BFLocalizedString(kTranslationChooseCountry, @"Select country")
                                        rows:self.languageItems
                            initialSelection:initialSelection
                                   doneBlock:doneBlock
                                 cancelBlock:nil
                                      origin:sender];
}

#pragma mark - Continue Button Action

- (IBAction)continueButtonAction:(id)sender {
    // if the user has selected the language
    // then we are OK and he can proceed
    if (self.selectedShop) {
        // set first launch flag
        [[BFAppSessionInfo sharedInfo]setFirstLaunch:false];
        // selected language
        [[BFAppPreferences sharedPreferences]setSelectedLanguage:self.selectedShop.language];
        // selected shop
        [[BFAppPreferences sharedPreferences]setSelectedShop:self.selectedShop.shopID];
        // move to next page
        [self.delegate moveToNextPage];
    }
    // if the language has not been selected yet
    // then shake the button which shows the languages!
    else {
        [self shakeThatView:self.selectLanguageButton];
    }
}

#pragma mark - Animations

- (void)shakeThatView:(UIView *)view {
    POPSpringAnimation *shake = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    
    shake.springBounciness = 20;
    shake.velocity = @(3000);

    if (![view.layer pop_animationForKey:shakeAnimationKey]) {
        [view.layer pop_addAnimation:shake forKey:shakeAnimationKey];
    }
}


@end
