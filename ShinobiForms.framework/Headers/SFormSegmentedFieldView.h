//
//  SFormSegmentedFieldView.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import "SFormFieldView.h"

#import "SFormSegmentedControl.h"
#import "SFormChoiceField.h"

/** A view that allows a user to choice an option from a selection of choices.
 
 This view uses a `UISegmentedControl` as the `inputElement` to display the choice field's underlying `choices`.
 */
@interface SFormSegmentedFieldView : SFormFieldView

/** The date field model being presented. */
@property (nonatomic, strong) SFormChoiceField *model;

/** The input element displaying a set of options to be selected. */
@property (nonatomic, strong) SFormSegmentedControl *inputElement;

#pragma mark - Default Appearance
/** @name Default Appearance*/

/** The text color that is applied to `inputElement` when this field view enters its default state.*/
@property (nonatomic, strong) UIColor *defaultInputElementTextColor;

/** The font that is applied to `inputElement` when this field view enters its default state.*/
@property (nonatomic, strong) UIFont *defaultInputElementFont;

/** The text color that is applied to a segment in `inputElement` when it is selected.*/
@property (nonatomic, strong) UIColor *selectedInputElementTextColor;

/** The font that is applied to a segment in `inputElement` when it is selected.*/
@property (nonatomic, strong) UIFont *selectedInputElementFont;

#pragma mark - Valid Appearance
/** @name Valid Appearance*/

/** The tint color that is applied to `inputElement` when this field view enters its valid state.*/
@property (nonatomic, strong) UIColor *validInputElementTintColor;

#pragma mark - Invalid Appearance
/** @name Invalid Appearance*/

/** The tint color that is applied to `inputElement` when this field view enters its invalid state.*/
@property (nonatomic, strong) UIColor *invalidInputElementTintColor;

@end
