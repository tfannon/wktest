//
//  SGridAutoMultiLineCell.h
//  Dev
//
//  Created by Ryan Grey on 09/01/2013.
//
//

#import "SGridTextViewDelegate.h"
#import "SGridTextInputCell.h"
@class SGridTextLabel;

/** This provides an easy mechanism for populating your cells with multi-line text content. An object of this class has a textLabel property for convenience. Set the text of this property (`[textLabel setText:stringObject]`) to quickly generate content for an object of this class. Objects of this class are editable by the user - see the singleTapEventMask and doubleTapEventMask property of SGrid to customise this.*/

@interface SGridAutoMultiLineCell : SGridTextInputCell <UITextViewDelegate, SGridTextViewDelegate>


/** The text label responsible for rendering multi-line text content in this cell.
 
 *Important* When a multi line text cell goes into editing mode this UILabel is visually switched with a UITextView (editingTextView) to allow keyboard input. This textLabel is still an accessible property, but the UI presented within the cell is rendered via editingTextView.*/
@property (nonatomic, retain) UILabel *textLabel;

/** The text view that is temporarily used whilst the cell is editing. When the cell is not editing this property will return nil.*/
@property (nonatomic, retain, readonly) UITextView *editingTextView;

@end
