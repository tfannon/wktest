//
//  SGridTextInputCell.h
//  Dev
//
//  Created by Ryan Grey on 09/01/2013.
//
//

#import "SGridCell.h"
@protocol SGridTextInputView;

@interface SGridTextInputCell : SGridCell



/**@name Text*/

/**
* This property is a convenience for getting and setting the text on this cell's text input view.
*
* The type of the text input view and how it is connected to this property is the responsibility of subclasses.
*/
@property (nonatomic, retain) NSString *text;


/** @name Deprecated*/

/** The amount of space to left indent the textField view.
 
 This cell calls this method when setFrame: is called to query how much space it should leave between the left hand edge of the cell and the textField.
 
 @warning *Important:* This property has been deprecated in preference of `contentInset`.
 
 @return A CGFloat representing the left indent for the textField.*/
@property (nonatomic, assign) CGFloat leftIndentForTextView __attribute__((deprecated("Use `contentInset` instead")));

/** The amount of space to right indent the textField view.
 
 This cell calls this method when setFrame: is called to query how much space it should leave between the right hand edge of the cell and the textField.
 
 @warning *Important:* This property has been deprecated in preference of `contentInset`.
 
 @return A CGFloat representing the right indent for the textField.*/
@property (nonatomic, assign) CGFloat rightIndentForTextView __attribute__((deprecated("Use `contentInset` instead")));

/** The amount of space to top indent the textField view.
 
 This cell calls this method when setFrame: is called to query how much space it should leave between the top edge of the cell and the textField.
 
 @warning *Important:* This property has been deprecated in preference of `contentInset`.
 
 @return A CGFloat representing the top indent for the textField.*/
@property (nonatomic, assign) CGFloat topIndentForTextView __attribute__((deprecated("Use `contentInset` instead")));

/** The amount of space to bottom indent the textField view.
 
 This cell calls this method when setFrame: is called to query how much space it should leave between the bottom edge of the cell and the textField.
 
 @warning *Important:* This property has been deprecated in preference of `contentInset`.
 
 @return A CGFloat representing the bottom indent for the textField.*/
@property (nonatomic, assign) CGFloat bottomIndentForTextView __attribute__((deprecated("Use `contentInset` instead")));


/** @name Layout*/

/**
* Returns the frame to be used for the text input view of this cell.
*
* This method should not be called directly and is instead intended to be overridden in subclasses wishing to customize the size and position of the text input view.
*
* This method is called as part of layoutSubviews.
*/
- (CGRect)textInputFrame;

@end
