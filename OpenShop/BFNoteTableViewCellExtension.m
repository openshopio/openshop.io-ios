//
//  BFNoteTableViewCellExtension.m
//  OpenShop
//
//  Created by Petr Škorňok on 20.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFNoteTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTextViewTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "BFKeyboardToolbar.h"

/**
 * note item table view cell reuse identifier.
 */
static NSString *const noteItemCellReuseIdentifier                 = @"BFOrderFormNoteTableViewCell";
/**
 * Button footer view reuse identifier.
 */
static NSString *const buttonFooterViewReuseIdentifier             = @"BFTableViewButtonHeaderFooterViewIdentifier";
/**
 * Extension header view reuse identifier.
 */
static NSString *const extensionHeaderViewReuseIdentifier          = @"BFTableViewGroupedHeaderFooterViewIdentifier";
/**
 * Extension header view nib file name.
 */
static NSString *const extensionHeaderViewNibName                  = @"BFTableViewGroupedHeaderFooterView";
/**
 * Button header view nib file name.
 */
static NSString *const buttonFooterViewNibName                     = @"BFTableViewButtonHeaderFooterView";
/**
 * Extension table view cell height.
 */
static CGFloat const extensionCellHeight                           = 44.5;
/**
 * Extension header view height.
 */
static CGFloat const extensionHeaderViewHeight                     = 30.0;
/**
 * Extension footer view height.
 */
static CGFloat const extensionEmptyFooterViewHeight                = 10.0;

@interface BFNoteTableViewCellExtension ()

/**
 * Note items data source.
 */
@property (nonatomic, strong) NSArray *noteItems;
/**
 * Note string from user input.
 */
@property (nonatomic, strong) NSString *noteString;

@end


@implementation BFNoteTableViewCellExtension

#pragma mark - Initialization

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController {
    self = [super initWithTableViewController:tableViewController];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithTableViewController:(BFTableViewController *)tableViewController inputAccessoryView:(UIView *)inputAccessoryView {
    self = [super initWithTableViewController:tableViewController
                           inputAccessoryView:inputAccessoryView];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // note items
    self.noteItems = @[@(BFNoteItemNote)];
}

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:extensionHeaderViewNibName bundle:nil] forHeaderFooterViewReuseIdentifier:extensionHeaderViewReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.noteItems count];
}

/*
 * Dynamic textView height
 */
- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return UITableViewAutomaticDimension;
}

- (CGFloat)getEstimatedHeightForRowAtIndex:(NSUInteger)index {
    return extensionCellHeight;
}

- (void)willDisplayCell:(UITableViewCell *)cell atIndex:(NSInteger)index {
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    BFTextViewTableViewCell *cell = (BFTextViewTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:noteItemCellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTextViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noteItemCellReuseIdentifier];
    }

    if ([self.inputAccessoryView isKindOfClass:[BFKeyboardToolbar class]]) {
        BFKeyboardToolbar *inputAccessoryView = (BFKeyboardToolbar *)self.inputAccessoryView;
        [inputAccessoryView addInputView:cell.textView];
        cell.textView.inputAccessoryView = self.inputAccessoryView;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:extensionHeaderViewReuseIdentifier];
    if(!textHeaderView) {
        textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:extensionHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationNote, @"Note") uppercaseString]];
    return textHeaderView;
}

- (CGFloat)getHeaderHeight {
    return extensionHeaderViewHeight;
}

- (CGFloat)getFooterHeight {
    return extensionEmptyFooterViewHeight;
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    // deselect row
    [self.tableViewController deselectRowAtIndex:index onExtension:self];
}

@end
