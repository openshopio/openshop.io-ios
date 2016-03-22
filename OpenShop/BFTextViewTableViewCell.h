//
//  BFTextViewTableViewCell.h
//  OpenShop
//
//  Created by Petr Škorňok on 20.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFTableViewCell.h"
#import "BFTextView.h"

/**
 * `BFTextViewTableViewCell` adds textView to the basic table view cell.
 */
@interface BFTextViewTableViewCell : BFTableViewCell

/**
 * TextView for user input.
 */
@property (nonatomic, weak) IBOutlet BFTextView *textView;

@end
