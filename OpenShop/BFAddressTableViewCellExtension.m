//
//  BFAdressSingleTableViewCellExtension.m
//  OpenShop
//
//  Created by Petr Škorňok on 18.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFAddressTableViewCellExtension.h"
#import "BFTableViewCell.h"
#import "BFTextFieldTableViewCell.h"
#import "BFTableViewHeaderFooterView.h"
#import "BFKeyboardToolbar.h"
#import "BFAppStructure.h"
#import "BFOrderFormViewController.h"
#import "ShoppingCart.h"

/**
 * Single TextField item table view cell reuse identifier.
 */
static NSString *const singleTextFieldItemCellReuseIdentifier      = @"BFOrderFormAddressSingleTableViewCell";
/**
 * Double TextField item table view cell reuse identifier.
 */
static NSString *const doubleTextFieldItemCellReuseIdentifier      = @"BFOrderFormAddressDoubleTableViewCell";
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
static CGFloat const extensionCellHeight                           = 72.0;
/**
 * Extension header view height.
 */
static CGFloat const extensionHeaderViewHeight                     = 40.0;
/**
 * Extension footer view height.
 */
static CGFloat const extensionEmptyFooterViewHeight                = 15.0;

@interface BFAddressTableViewCellExtension ()

/**
 * Address items data source.
 */
@property (nonatomic, strong) NSArray *addressFieldItems;

@end


@implementation BFAddressTableViewCellExtension

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
    // shipping and payment items
    self.addressFieldItems = @[@(BFAddressRowName), @(BFAddressRowEmail), @(BFAddressRowStreetHouseNumber), @(BFAddressRowCityPostalCode), @(BFAddressRowPhoneNumber)];
}

- (void)didLoad {
    // register header / footer views
    [self.tableView registerNib:[UINib nibWithNibName:extensionHeaderViewNibName bundle:nil]forHeaderFooterViewReuseIdentifier:extensionHeaderViewReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSUInteger)getNumberOfRows {
    return [self.addressFieldItems count];
}

- (CGFloat)getHeightForRowAtIndex:(NSUInteger)index {
    return extensionCellHeight;
}

- (UITableViewCell *)getCellForRowAtIndex:(NSInteger)index {
    NSString *cellReuseIdentifier;
    switch (index) {
        case BFAddressRowName:
        case BFAddressRowEmail:
        case BFAddressRowPhoneNumber:
            cellReuseIdentifier = singleTextFieldItemCellReuseIdentifier;
            break;
            
        default:
            cellReuseIdentifier = doubleTextFieldItemCellReuseIdentifier;
            break;
    }
    
    BFTextFieldTableViewCell *cell = (BFTextFieldTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if(!cell) {
        cell = [[BFTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (index) {
        case BFAddressRowName:
            cell.mainLabel.text = BFLocalizedString(kTranslationName, @"Name");
            cell.mainTextField.placeholder = BFLocalizedString(kTranslationNamePlaceholder, @"John Doe");
            cell.mainTextField.text = [[ShoppingCart sharedCart]name];
            cell.mainTextField.tag = BFAddressItemName;
            break;
            
        case BFAddressRowEmail:
            cell.mainLabel.text = BFLocalizedString(kTranslationEmail, @"Email");
            cell.mainTextField.placeholder = BFLocalizedString(kTranslationEmailPlaceholder, @"pete@email.com");
            cell.mainTextField.text = [[ShoppingCart sharedCart]email];
            cell.mainTextField.tag = BFAddressItemEmail;
            cell.mainTextField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
            
        case BFAddressRowStreetHouseNumber:
            cell.mainLabel.text = BFLocalizedString(kTranslationStreet, @"Street");
            cell.mainTextField.placeholder = BFLocalizedString(kTranslationStreetPlaceholder, @"Eternity street");
            cell.mainTextField.text = [[ShoppingCart sharedCart] addressStreet];
            cell.mainTextField.tag = BFAddressItemStreet;

            cell.additionalLabel.text = BFLocalizedString(kTranslationHouseNo, @"House number");
            cell.additionalTextField.placeholder = BFLocalizedString(kTranslationHouseNoPlaceholder, @"12");
            cell.additionalTextField.text = [[ShoppingCart sharedCart] addressHouseNumber];
            cell.additionalTextField.tag = BFAddressItemHouseNumber;
            break;

        case BFAddressRowCityPostalCode:
            cell.mainLabel.text = BFLocalizedString(kTranslationCity, @"City");
            cell.mainTextField.placeholder = BFLocalizedString(kTranslationCityPlaceholder, @"Sacramento");
            cell.mainTextField.text = [[ShoppingCart sharedCart] addressCity];
            cell.mainTextField.tag = BFAddressItemCity;

            cell.additionalLabel.text = BFLocalizedString(kTranslationPostalCode, @"ZIP Code");
            cell.additionalTextField.placeholder = BFLocalizedString(kTranslationPostalCodePlaceholder, @"95837");
            cell.additionalTextField.text = [[ShoppingCart sharedCart] addressPostalCode];
            cell.additionalTextField.tag = BFAddressItemPostalCode;
            break;
            
        case BFAddressRowPhoneNumber:
            cell.mainLabel.text = BFLocalizedString(kTranslationPhoneNumber, @"Phone number");
            cell.mainTextField.placeholder = BFLocalizedString(kTranslationPhoneNumberPlaceholder, @"+420 755 999 090");
            cell.mainTextField.text = [[ShoppingCart sharedCart]phone];
            cell.mainTextField.tag = BFAddressItemPhoneNumber;
            cell.mainTextField.keyboardType = UIKeyboardTypePhonePad;
            break;

        default:
            break;
    }
    
    if ([self.inputAccessoryView isKindOfClass:[BFKeyboardToolbar class]]) {
        BFKeyboardToolbar *inputAccessoryView = (BFKeyboardToolbar *)self.inputAccessoryView;
        
        [inputAccessoryView addInputView:cell.mainTextField];
        cell.mainTextField.inputAccessoryView = self.inputAccessoryView;

        [inputAccessoryView addInputView:cell.additionalTextField];
        cell.additionalTextField.inputAccessoryView = self.inputAccessoryView;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)getHeaderView {
    BFTableViewHeaderFooterView *textHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:extensionHeaderViewReuseIdentifier];
    if(!textHeaderView) {
        textHeaderView = [[BFTableViewHeaderFooterView alloc] initWithReuseIdentifier:extensionHeaderViewReuseIdentifier];
    }
    [textHeaderView.headerlabel setText:[BFLocalizedString(kTranslationContactInformation, @"Contact information") uppercaseString]];
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
