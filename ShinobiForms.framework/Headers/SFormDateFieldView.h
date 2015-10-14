//
//  SFormDateFieldView.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import "SFormTextPresenterFieldView.h"

@class SFormDateField;
@protocol SFormFieldModelViewConverter;

/** A view that allows the user to input dates via a date picker.
 
 This view uses a `UITextField` as the `inputElement` to display the underlying `model`. It also uses a `UIDatePicker` as the `inputElement`'s `inputView` to allow the user to input dates.
  */
@interface SFormDateFieldView : SFormTextPresenterFieldView

/** The date field model being presented. */
@property (nonatomic, strong) SFormDateField *model;

/** A `UIDatePicker` instance presented as the `inputView` for the field's `inputElement`.
 
 Presentation of this date picker occurs when this field view becomes first responder (i.e. a user taps in the `inputElement`).
 */
@property (nonatomic, strong, readonly) UIDatePicker *datePicker;

@end
