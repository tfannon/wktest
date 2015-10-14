//
//  SFormSliderFieldView.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFormFieldView.h"
#import "SFormRangedNumberField.h"

/** A field that allows the user to pick a number between a minimum and a maximum.
 
  This view uses a `UISlider` as the `inputElement`.
 */
@interface SFormSliderFieldView : SFormFieldView

/** The ranged number field model being presented.
 */
@property (nonatomic, strong) SFormRangedNumberField *model;

/** An input element for selecting a number within a given range.
 */
@property (nonatomic, strong) UISlider *inputElement;

#pragma mark - Valid Appearance
/** @name Valid Appearance*/

/** The tint color that is applied to `inputElement` when this field view enters its valid state.*/
@property (nonatomic, strong) UIColor *validInputElementTintColor;

#pragma mark - Invalid Appearance
/** @name Invalid Appearance*/

/** The tint color that is applied to `inputElement` when this field view enters its invalid state.*/
@property (nonatomic, strong) UIColor *invalidInputElementTintColor;

#pragma mark - Focused Appearance
/** @name Focused Appearance*/

/** The tint color that is applied to `inputElement` when this field view enters its focused state.*/
@property (nonatomic, strong) UIColor *focusedInputElementTintColor;

/** The border width that is applied to `inputElement` when this field view enters its focused state.*/
@property (nonatomic, assign) CGFloat focusedInputElementBorderWidth;

@end
