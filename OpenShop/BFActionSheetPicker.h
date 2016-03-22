//
//  BFActionSheetPicker.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "AbstractActionSheetPicker.h"
#import "BFNSelection.h"


NS_ASSUME_NONNULL_BEGIN


@class BFActionSheetPicker;

/**
 * Action sheet picker completion block type.
 */
typedef void(^BFNActionDoneBlock)(BFActionSheetPicker *picker, NSInteger selectedIndex, id<BFNSelection> selectedValue);
/**
 * Action sheet picker cancellation block type.
 */
typedef void(^BFNActionCancelBlock)(BFActionSheetPicker *picker);


/**
 * `BFActionSheetPicker` represents custom action sheet picker. It is designed to work with datasource
 * items implementing the `BFNSelection` protocol.
 */
@interface BFActionSheetPicker : AbstractActionSheetPicker <UIPickerViewDelegate, UIPickerViewDataSource>

/**
 * Creates and displays an action sheet picker with title, data selection items, initial selection index, target receiving
 * selection results, success action and cancel action and the sender object.
 *
 * @param title The picker title.
 * @param data The picker selection items datasource.
 * @param index The picker initial selection index.
 * @param target The picker target receiving results.
 * @param successAction The picker successful selection action.
 * @param cancelActionOrNil The picker cancel action.
 * @param origin The picker presenting object.
 * @return The newly-initialized and presented `BFActionSheetPicker`.
 */
+ (instancetype)showPickerWithTitle:(NSString *)title rows:(NSArray<id<BFNSelection>> *)data initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(nullable SEL)cancelActionOrNil origin:(id)origin;

/**
 * Creates an action sheet picker with title, data selection items, initial selection index, target receiving
 * selection results, success action and cancel action and the sender object.
 *
 * @param title The picker title.
 * @param data The picker selection items datasource.
 * @param index The picker initial selection index.
 * @param target The picker target receiving results.
 * @param successAction The picker successful selection action.
 * @param cancelActionOrNil The picker cancel action.
 * @param origin The picker presenting object.
 * @return The newly-initialized `BFActionSheetPicker`.
 */
- (instancetype)initWithTitle:(NSString *)title rows:(NSArray<id<BFNSelection>> *)data initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(nullable SEL)cancelActionOrNil origin:(id)origin;

/**
 * Creates and displays an action sheet picker with title, data selection items, initial selection index,
 * success block and cancel block callbacks and the sender object.
 *
 * @param title The picker title.
 * @param data The picker selection items datasource.
 * @param index The picker initial selection index.
 * @param doneBlock The successful selection block callback.
 * @param cancelBlock The cancel block callback.
 * @param origin The picker presenting object.
 * @return The newly-initialized and presented `BFActionSheetPicker`.
 */
+ (instancetype)showPickerWithTitle:(NSString *)title rows:(NSArray<id<BFNSelection>> *)data initialSelection:(NSInteger)index doneBlock:(BFNActionDoneBlock)doneBlock cancelBlock:(nullable BFNActionCancelBlock)cancelBlock origin:(id)origin;

/**
 * Creates an action sheet picker with title, data selection items, initial selection index,
 * success block and cancel block callbacks and the sender object.
 *
 * @param title The picker title.
 * @param data The picker selection items datasource.
 * @param index The picker initial selection index.
 * @param doneBlock The successful selection block callback.
 * @param cancelBlock The cancel block callback.
 * @param origin The picker presenting object.
 * @return The newly-initialized `BFActionSheetPicker`.
 */
- (instancetype)initWithTitle:(NSString *)title rows:(NSArray<id<BFNSelection>> *)data initialSelection:(NSInteger)index doneBlock:(BFNActionDoneBlock)doneBlock cancelBlock:(nullable BFNActionCancelBlock)cancelBlock origin:(id)origin;

/**
 * The selection datasource items.
 */
@property (nonatomic,strong) NSArray<id<BFNSelection>> *data;
/**
 * The selected item index.
 */
@property (nonatomic,assign) NSInteger selectedIndex;
/**
 * The successful selection block callback.
 */
@property (nonatomic, copy) BFNActionDoneBlock onActionSheetDone;
/**
 * The cancel block callback.
 */
@property (nonatomic, copy) BFNActionCancelBlock onActionSheetCancel;


@end


NS_ASSUME_NONNULL_END


