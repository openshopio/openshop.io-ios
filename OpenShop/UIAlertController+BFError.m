//
//  UIAlertController+BFError.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "UIAlertController+BFError.h"
@import ObjectiveC.runtime;


@implementation UIAlertController (BFError)


#pragma mark - Initialization

+ (instancetype)alertControllerWithError:(BFError *)error preferredStyle:(UIAlertControllerStyle)preferredStyle completionBlock:(BFErrorCompletionBlock)block {
    // title
    NSString *title = [error localizedDescription];
    
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
    NSString *message = [messageArray componentsJoinedByString:@"\n"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (alertController) {
        // buttons (alert actions)
        NSArray *recoveryOptions;
        if ([error recoveryAttempter]) {
            recoveryOptions = [error localizedRecoveryOptions];
            for (int i = 0; i < recoveryOptions.count; i++) {
                NSString *recoveryOption = [recoveryOptions objectAtIndex:i];
                UIAlertAction *alertAction = [self alertActionForError:error title:recoveryOption optionIndex:@(i) completionBlock:block];
                [alertController addAction:alertAction];
            }
        }
        // at least a single button
        if (![error recoveryAttempter] || !recoveryOptions.count) {
            UIAlertAction *alertAction = [self alertActionForError:error title:BFLocalizedString(kTranslationErrorDefaultButtonTitle, @"OK") optionIndex:nil completionBlock:block];
            [alertController addAction:alertAction];
        }
    }

    return alertController;
}

+ (UIAlertAction *)alertActionForError:(BFError *)error title:(NSString *)title optionIndex:(NSNumber *)optionIndex completionBlock:(BFErrorCompletionBlock)block {
    return [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // attempt recovery
        if(optionIndex) {
            BOOL recovered = [[error recoveryAttempter]attemptRecoveryFromError:error optionIndex:[optionIndex integerValue]];
            if(block) {
                block(recovered, optionIndex);
            }
        }
        // cancel action
        else {
            if(block) {
                block(false, nil);
            }
        }
    }];
}


@end
