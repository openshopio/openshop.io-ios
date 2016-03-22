//
//  UIAlertView+BFError.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "UIAlertView+BFError.h"
#import "NSObject+BFRuntimeAdditions.h"

/**
 * Error association key identifying alert view delegates.
 */
static char *const BFErrorAlertViewDelegatesAssociationkey = "BFError_alertViewDelegates";


#pragma mark - AlertView Delegate

@interface BFAlertViewDelegate : NSObject <UIAlertViewDelegate>

/**
 * The error information.
 */
@property (nonatomic, strong) NSError *error;
/**
 * The completion block.
 */
@property (copy) BFErrorCompletionBlock completionBlock;

/**
 * Creates an alert view delegate with a specified error and completion block to be executed when the
 * alert view was dismissed.
 *
 * @param error The error information.
 * @param block The completion block.
 * @return The newly-initialized `BFAlertViewDelegate`.
 */
- (instancetype)initWithError:(BFError *) error completionBlock:(BFErrorCompletionBlock)block;

@end



@implementation BFAlertViewDelegate


#pragma mark - BFAlertViewDelegate Initialization

- (instancetype)initWithError:(BFError *)error completionBlock:(BFErrorCompletionBlock)block {
    self = [self init];
    if (self) {
        self.completionBlock = block;
        self.error = error;
    }
    return self;
}


#pragma mark - UIAlertViewDelegate Protocol

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    BOOL recovered = false;
    
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    NSInteger recoveryIndex = [[self.error localizedRecoveryOptions] indexOfObject:buttonTitle];
    // try to recover if attempter exists
    if ([self.error recoveryAttempter]) {
        if (recoveryIndex != NSNotFound) {
            recovered = [[self.error recoveryAttempter]attemptRecoveryFromError:self.error optionIndex:recoveryIndex];
        }
    }
    
    // report results
    if(self.completionBlock) {
        self.completionBlock(recovered, @(recoveryIndex));
    }
    // remove delegate
    [self BFN_removeAssociatedObject:self withKey:BFErrorAlertViewDelegatesAssociationkey];
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    // report results
    if(self.completionBlock) {
        self.completionBlock(false, @(NSIntegerMax));
    }
    // remove delegate
    [self BFN_removeAssociatedObject:self withKey:BFErrorAlertViewDelegatesAssociationkey];
}

@end



@implementation UIAlertView (BFError)


#pragma mark - UIAlertView Initialization

- (instancetype)initWithError:(BFError *)error completionBlock:(BFErrorCompletionBlock)block {
    self = [self init];
    if (self) {
        // title
        self.title = [error localizedDescription];
        
        // message
        NSString *failureReason = [error localizedFailureReason];
        NSString *recoverySuggestion = [error localizedRecoverySuggestion];
        NSMutableArray *messageArray = [[NSMutableArray alloc]init];
        if (failureReason) {
            [messageArray addObject:failureReason];
        }
        if (recoverySuggestion) {
            [messageArray addObject:recoverySuggestion];
        }
        self.message = [messageArray componentsJoinedByString:@"\n"];
        
        // buttons
        NSArray *recoveryOptions;
        if ([error recoveryAttempter]) {
            recoveryOptions = [error localizedRecoveryOptions];
            for (NSString *option in recoveryOptions) {
                [self addButtonWithTitle:option];
            }
        }
        // at least a single button
        if (![error recoveryAttempter] || !recoveryOptions.count) {
            [self addButtonWithTitle:BFLocalizedString(kTranslationErrorDefaultButtonTitle, @"OK")];
        }
        // delegate
        BFAlertViewDelegate *delegate = [[BFAlertViewDelegate alloc]initWithError:error completionBlock:block];
        self.delegate = delegate;
        // associate delegate
        [self BFN_addAssociatedObject:delegate forKey:BFErrorAlertViewDelegatesAssociationkey];
    }
    return self;
}


@end



