//
//  SFormTextFieldView.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import "SFormTextPresenterFieldView.h"

#import "SFormTextField.h"

@protocol SFormFieldModelViewConverter;

/** A view that allows the user to input text via a keyboard.
 
 This view uses a `UITextField` as the `inputElement` to display the underlying field.
 
 This view is typically used to present `SFormTextField` model objects.
 */

@interface SFormTextFieldView : SFormTextPresenterFieldView

/** The date field model being presented. */
@property (nonatomic, strong) SFormTextField *model;

@end
