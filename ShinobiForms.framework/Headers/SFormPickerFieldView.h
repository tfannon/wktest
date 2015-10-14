//
//  SFormPickerFieldView.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import "SFormTextPresenterFieldView.h"
#import "SFormPickerField.h"

@protocol SFormFieldModelViewConverter;

/** A view that allows the user to input values via a `UIPickerView`.
 
 This view uses a `UITextField` as the `inputElement` to display the underlying field. It also uses a `UIPickerView` as the `inputElement`'s `inputView` to allow the user to input values.
 */
@interface SFormPickerFieldView : SFormTextPresenterFieldView

/** The `SFormPickerField` model that this view is presenting. */
@property (nonatomic, strong) SFormPickerField *model;

/** The `UIPickerView` used as the `inputView` for the field's `inputElement`. */
@property (nonatomic, strong, readonly) UIPickerView *picker;

@end