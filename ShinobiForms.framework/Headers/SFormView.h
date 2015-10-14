//
//  SFormView.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShinobiForm, SFormResponderFieldViewIterator;

@protocol SFormLayout, SFormNavigationToolbar, SFormFieldViewIterator;

/** A view that represents a `ShinobiForm` model.
 
 This view contains a number of `SFormSectionView`s.
 */
@interface SFormView : UIView

/** The model being presented. */
@property (nonatomic, strong) ShinobiForm *model;

/** The section views this form view displays. */
@property (nonatomic, copy) NSArray *sectionViews;

#pragma mark - Layout
/** @name Layout */

/** Used to layout the sections added to this view.
 
 The `layout` is used by `SFormView` in its `layoutSubviews` method. Setting this to nil will stop the view from doing any layout if you want to set frames manually.
 
 Default is an instance of the class `SFormLayoutAlignedVertically`.
 */
@property (nonatomic, strong) id<SFormLayout> layout;

#pragma mark - Submit Button
/** @name Submit Button*/

/** When this button is pressed, the form's `submit` method is called.
 
 A `UIButton` set on this property will add the parent form as a target, calling `submit` on the form for the event touch up inside. We  provide a `UIButton` subclass, `SFormSubmitButton`, which is styled to match our form styling.
 
 By default the form's button will be `nil`.
 */
@property (nonatomic, strong) UIButton *submitButton;

#pragma mark - Field Navigation
/** @name Field Navigation */

/** The view to be placed above the keyboard when editing fields.
 
 The keyboard toolbar view will be set as the `inputAccessoryView` for any text fields added to the form.
 
 By default this is an instance of `SFormToolbar`.
 */
@property (nonatomic, strong) id<SFormNavigationToolbar> keyboardToolbar;

/** Iterates over the field views in the form.
 
 This object is used to control the navigation order of fields in the form. Set this object to modify the navigation order of the fields.
 */
@property (nonatomic, strong) id<SFormFieldViewIterator> fieldViewIterator;

@end
