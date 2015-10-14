//
//  SGridTextView.h
//  Dev
//
//  Created by Ryan Grey on 18/02/2013.
//
//

#import <UIKit/UIKit.h>
#import "SGridTextViewDelegate.h"

/** This text view is largely identical to UITextView - except that it will notify its delegate if it has changed size. 
 
 There is no need to use this class yourself in any custom cells. When using a multi-line cell, you should treat the text view exactly as you would an UITextView.
 
 */

@interface SGridTextView : UITextView

- (id) init UNAVAILABLE_ATTRIBUTE;
- (id) initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;

- (id) initWithFrame:(CGRect)frame withDelegate:(id<SGridTextViewDelegate>) delegate;

@end
