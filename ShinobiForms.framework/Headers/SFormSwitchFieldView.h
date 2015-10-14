//
//  SFormSwitchFieldView.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import "SFormFieldView.h"
#import "SFormBooleanField.h"

/** A view that allows the user to input a boolean value via a `UISwitch`.
 
 This view uses a `UISwitch` as the `inputElement` to display the underlying field. It also uses a `UISwitch` as the `inputElement`'s `inputView` to allow the user to input the boolean.
 */
@interface SFormSwitchFieldView : SFormFieldView

/** The boolean field model being presented. */
@property (nonatomic, strong) SFormBooleanField *model;

/** The `UISwitch` used as the `inputView` for the field's `inputElement`. */
@property (nonatomic, strong) UISwitch *inputElement;

#pragma mark - Default Appearance
/** @name Default Appearance */

/** The onTintColor that is applied to the `UISwitch` when this field view enters its default state.
 
 The color will be visible when the switch is in it's 'on' state. 
 */
@property (nonatomic, strong) UIColor *onTintColor;

@end
