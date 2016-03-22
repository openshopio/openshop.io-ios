//
//  BFActionSheetPicker.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFActionSheetPicker.h"
#import "UIFont+BFFont.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import <Masonry.h>


/**
 * Default action sheet picker height.
 */
static CGFloat const actionSheetPickerHeight      = 216.0f;
/**
 * Default action sheet picker origin.
 */
static CGFloat const actionSheetPickerOriginY     = 40.0f;
/**
 * Default action sheet picker label width.
 */
static CGFloat const actionSheetPickerLabelWidth  = 120.0f;
/**
 * Default action sheet picker label height.
 */
static CGFloat const actionSheetPickerLabelHeight = 60.0f;



@interface BFActionSheetPicker()

@end


@implementation BFActionSheetPicker


#pragma mark - Initialization & Presentation

- (instancetype)initWithTitle:(NSString *)title rows:(NSArray<id<BFNSelection>> *)data initialSelection:(NSInteger)index doneBlock:(BFNActionDoneBlock)doneBlock cancelBlock:(BFNActionCancelBlock)cancelBlockOrNil origin:(id)origin {
    self = [self initWithTarget:nil successAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.data = data;
        self.selectedIndex = index;
        self.title = title;
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlockOrNil;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title rows:(NSArray<id<BFNSelection>> *)data initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    self = [self initWithTarget:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    if (self) {
        self.data = data;
        self.selectedIndex = index;
        self.title = title;
    }
    return self;
}

+ (instancetype)showPickerWithTitle:(NSString *)title rows:(NSArray<id<BFNSelection>> *)data initialSelection:(NSInteger)index doneBlock:(BFNActionDoneBlock)doneBlock cancelBlock:(BFNActionCancelBlock)cancelBlock origin:(id)origin {
    BFActionSheetPicker *picker = [[BFActionSheetPicker alloc] initWithTitle:title rows:data initialSelection:index doneBlock:doneBlock cancelBlock:cancelBlock origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

+ (instancetype)showPickerWithTitle:(NSString *)title rows:(NSArray<id<BFNSelection>> *)data initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    BFActionSheetPicker *picker = [[BFActionSheetPicker alloc] initWithTitle:title rows:data initialSelection:index target:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    [picker showActionSheetPicker];
    return picker;
}


#pragma mark - Picker Configuration

- (UIView *)configuredPickerView {
    if (!self.data || self.data.count == 0) {
        return nil;
    }
    
    CGRect pickerFrame = CGRectMake(0, actionSheetPickerOriginY, self.viewSize.width, actionSheetPickerHeight);
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = (self.data.count != 0);
    picker.userInteractionEnabled =  (self.data.count != 0);
    // initial selection
    [picker selectRow:self.selectedIndex inComponent:0 animated:NO];
    
    // save reference to the picker so we can clear the dataSource / delegate when dismissing
    self.pickerView = picker;
    return picker;
}


#pragma mark - Picker Selection

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {
    if (self.onActionSheetDone) {
        id selectedObject = self.data.count ? [self.data objectAtIndex:self.selectedIndex] : nil;
        _onActionSheetDone(self, self.selectedIndex, selectedObject);
    }
    else if (target && [target respondsToSelector:successAction]) {
        NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:successAction]];
        myInvocation.target = target;
        myInvocation.selector = successAction;
        
        // set selected index argument
        if(myInvocation.methodSignature.numberOfArguments-1 > kMinNumberOfMethodArguments) {
            [myInvocation setArgument:&_selectedIndex atIndex:myInvocation.methodSignature.numberOfArguments-2];
            [myInvocation setArgument:&origin atIndex:myInvocation.methodSignature.numberOfArguments-1];
        }
        [myInvocation invoke];
    }
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionSheetCancel) {
        _onActionSheetCancel(self);
    }
    else if (target && cancelAction && [target respondsToSelector:cancelAction]) {
        NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:cancelAction]];
        myInvocation.target = target;
        myInvocation.selector = cancelAction;
        [myInvocation invoke];
    }
}


#pragma mark - UIPickerViewDelegate / DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndex = row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.data.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    id<BFNSelection> selection = [self.data objectAtIndex:row];

    // selection item label
    UILabel *selectionItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, actionSheetPickerLabelWidth, actionSheetPickerLabelHeight)];
    NSString *title;
    if ([selection respondsToSelector:@selector(displayName)]) {
        title = [[self.data objectAtIndex:row]displayName];
    }

    selectionItemLabel.text = title;
    selectionItemLabel.textAlignment = NSTextAlignmentCenter;
    selectionItemLabel.font = [UIFont BFN_robotoRegularWithSize:14.0];
    selectionItemLabel.backgroundColor = [UIColor clearColor];
    
    // selection item image 
    UIImageView *imageView;
    if ([selection respondsToSelector:@selector(displayImageURL)]) {
        NSURL *imageURL = selection.displayImageURL;
        if (imageURL) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 30, 30)];
            [imageView setImageWithURL:imageURL];
        }

    }
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, actionSheetPickerLabelWidth, actionSheetPickerLabelHeight)];
    [tmpView insertSubview:selectionItemLabel atIndex:1];
    if (imageView) {
        [tmpView insertSubview:imageView atIndex:0];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(selectionItemLabel);
            make.right.equalTo(selectionItemLabel.mas_left).offset(-8);
        }];
    }
    
    [selectionItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(tmpView);
    }];
    return tmpView;
}



@end
