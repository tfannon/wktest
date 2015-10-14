//
//  SFormTextPresenterFieldView.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import "SFormFieldView.h"

/** This is an abstract class intended for concrete field subclasses wishing to present information in the form of text. 
 */
@interface SFormTextPresenterFieldView : SFormFieldView

#pragma mark -  Appearance
/** @name Appearance */

/** The input element responsible for text entry.
 
 This is an instance of `SFormTextInputElement` by default.
 */
@property (nonatomic, strong) UITextField *inputElement;

#pragma mark - Default Appearance
/** @name Default Appearance*/

/** The text color that is applied to `inputElement` when this field view enters its default state.*/
@property (nonatomic, strong) UIColor *defaultInputElementTextColor;

/** The font that is applied to `inputElement` when this field view enters its default state.*/
@property (nonatomic, strong) UIFont *defaultInputElementFont;

@end
