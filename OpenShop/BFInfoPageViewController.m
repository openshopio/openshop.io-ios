//
//  BFInfoPageViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFInfoPageViewController.h"
#import "BFAPIManager.h"
#import "UIFont+BFFont.h"
#import "UIWindow+BFOverlays.h"

/**
 * Text content container line fragment padding.
 */
static CGFloat const textContentPadding = 20.0;


@implementation BFInfoPageViewController


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
    self.animatesDismissal = true;
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // title view
    self.navigationItem.title = self.infoPage ? self.infoPage.title : @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(self.infoPage && self.infoPage.pageID) {
        // activity indicator
        [self.view.window showIndeterminateProgressOverlayWithTitle:BFLocalizedString(kTranslationLoading, @"Loading") animated:YES];
        // fetch info page content
        __weak __typeof__(self) weakSelf = self;
        [[BFAPIManager sharedManager] findInfoPageWithIdentification:(NSNumber *)self.infoPage.pageID completionBlock:^(NSArray *records, id customResponse, NSError *error) {
            __typeof__(weakSelf)strongSelf = weakSelf;
            if(!error && [records count]) {
                // info page with detail contents
                strongSelf.infoPage = (BFInfoPage *)[records firstObject];
                
                // info page text
                if(strongSelf.infoPage.text) {
                    NSMutableAttributedString *infoPageText = [[NSMutableAttributedString alloc] initWithData:(NSData *)[strongSelf.infoPage.text dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                                      options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                                           documentAttributes:nil
                                                                                                        error:nil];
                    [infoPageText addAttribute:NSFontAttributeName value:[UIFont BFN_robotoRegularWithSize:12] range:NSMakeRange(0, infoPageText.length)];
                    strongSelf.contentView.textContainer.lineFragmentPadding = textContentPadding;
                    strongSelf.contentView.attributedText = infoPageText;
                } 
            }
            else {
                // show error result
                BFError *customError = [BFError errorWithDomain:BFErrorDomainDataFetching];
                if(error) {
                    customError = [BFError errorWithError:error];
                }
                __weak __typeof__(self) weakSelf = strongSelf;
                [customError showAlertFromSender:strongSelf withCompletionBlock:^(BOOL recovered, NSNumber *optionIndex) {
                    // dismiss view controller
                    [weakSelf dismissAnimated:true];
                }];
            }
            // dismiss activity indicator
            [strongSelf.view.window dismissAllOverlaysWithCompletion:nil animated:true];
        }];
    }
}



@end


