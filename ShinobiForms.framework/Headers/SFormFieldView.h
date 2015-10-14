//
//  SFormFieldView.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SFormFieldLayout;
@class SFormFieldDecorationManager;
@class SFormField;
@protocol SFormFieldModelViewConverter;

#import "SFormInputElementResponder.h"

/** A view for data entry.

 `SFormField` is composed of the following subviews:
 - `label`: Synchronises to the `title` of its model.
 - `requiredLabel`: Is shown or hidden depending on the `required` value of its model.
 - `inputElement`: Synchronises to the `value` of it's model
 - `errorLabel`: Synchronises to the `invalidMessage` first failing validator of the model's `currentlyFailingValidators` array.
 
 Field can make use of different layouts - see `layout`.
 
 Available `SFormFieldView` subclasses are as follows:
 - `SFormTextFieldView`.
 - `SFormSegmentedFieldView`.
 - `SFormDateFieldView`.
 - `SFormSliderFieldView`.
 - `SFormPickerFieldView`.
 - `SFormSwitchFieldView`.
 */
@interface SFormFieldView : UIView <SFormInputElementResponder>

/** The model being presented. */
@property (nonatomic, strong) SFormField *model;

#pragma mark - Converting Values Between Model and View

/** @name Converting Values Between Model and View */

/** The converter used to ensure the correct format and object types are used when
 values are passed from `model` to this view and vice versa.*/
@property (nonatomic, strong) id<SFormFieldModelViewConverter> converter;

#pragma mark -  Appearance
/** @name Appearance */

/** The default layout used the field when a layout isn't provided. */
+(id<SFormFieldLayout>)defaultLayout;

/** The layout object used by this field.
 
 This layout object is delegated to when the field lays out (`layoutSubviews`) and is auto-sized (when calling `sizeToFit`). Setting this layout object allows you to change the layout of a field without
 subclassing.
 
 The available layouts:
 - `SFormFieldLayoutLabelOnTopOfInput`: The label is positioned above the input element (default).
 - `SFormFieldLayoutLabelLeftOfInput`: The label is positioned to the left of the input element.
 - `SFormFieldLayoutNoLabel`: The `label` will be hidden.
 
 To take manual control of layout you can nil out this object:
 
          fieldView.layout = nil
 
 Default is `SFormFieldLayoutLabelOnTopOfInput`.
 */
@property (nonatomic, strong) id<SFormFieldLayout> layout;

/** The field's title label.
 
 This label's text value is kept in sync with the `model`'s `title`.
 */
@property (nonatomic, strong) UILabel *label;

/* A label indicating that the field is a required field.
 
 This label is shown and hidden when the `model`'s `required` property is changed.
 */
@property (nonatomic, strong) UILabel *requiredLabel;

/** The view used for data entry.
 
 This view is kept in sync with the model's `value` property. The type of the value in the input element can differ from the type of the value on the `model` - the conversion is handled by the field's `converter`.
 */
@property (nonatomic, strong) UIView *inputElement;

/** A label showing validation error messages.
 
 This label displays the error message provided by the `model`'s first failing validator.
 */
@property (nonatomic, strong) UILabel *errorLabel;

/** Whether this view is enabled for input entry.
 
 Setting this to `NO` will change the field to look inactive, giving it a faded appearance.
 
 Defaults to `YES`.
 */
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

#pragma mark - Default Appearance
/** @name Default Appearance*/

/** Style the field in it's default look. */
-(void)updateAsDefault;

/** The text color that is applied to `label` when this field view enters its default state.*/
@property (nonatomic, strong) UIColor *defaultLabelTextColor;

/** The font that is applied to `label` when this field view enters its default state.*/
@property (nonatomic, strong) UIFont *defaultLabelFont;

/** The text color that is applied to `requiredLabel` when this field view enters its default state.*/
@property (nonatomic, strong) UIColor *defaultRequiredLabelTextColor;

/** The font that is applied to `requiredLabel` when this field view enters its default state.*/
@property (nonatomic, strong) UIFont *defaultRequiredLabelFont;

/** The background color that is applied to `inputElement` when this field view enters its default state.*/
@property (nonatomic, strong) UIColor *defaultInputElementBackgroundColor;

/** The border color that is applied to `inputElement` when this field view enters its default state.*/
@property (nonatomic, strong) UIColor *defaultInputElementBorderColor;

/** The border width that is applied to `inputElement` when this field view enters its default state.*/
@property (nonatomic, assign) CGFloat defaultInputElementBorderWidth;

/** The corner radius that is applied to `inputElement` when this field view enters its default state.*/
@property (nonatomic, assign) CGFloat defaultInputElementCornerRadius;

/** The tint color that is applied to `inputElement` when this field view enters its default state.*/
@property (nonatomic, strong) UIColor *defaultInputElementTintColor;

/** The font that is applied to `errorLabel` when this field view enters its default state.*/
@property (nonatomic, strong) UIFont *defaultErrorLabelFont;

/** The text color that is applied to `errorLabel` when this field view enters its default state.*/
@property (nonatomic, strong) UIColor *defaultErrorLabelTextColor;

#pragma mark - Valid Appearance
/**@name Valid Appearance */

/** Style the field in it's valid look. */
-(void)updateAsValid;

/** The border color that is applied to `inputElement` when this field view enters its valid state.*/
@property (nonatomic, strong) UIColor *validInputElementBorderColor;

/** The border width that is applied to `inputElement` when this field view enters its valid state.*/
@property (nonatomic, assign) CGFloat validInputElementBorderWidth;

#pragma mark - Invalid Appearance
/**@name Invalid Appearance */

/** Style the field in it's invalid look. */
-(void)updateAsInvalid;

/** The border color that is applied to `inputElement` when this field view enters its invalid state.*/
@property (nonatomic, strong) UIColor *invalidInputElementBorderColor;

/** The border width that is applied to `inputElement` when this field view enters its invalid state.*/
@property (nonatomic, assign) CGFloat invalidInputElementBorderWidth;

#pragma mark - Disabled Appearance
/**@name Disabled Appearance */

/** Style the field in it's disabled look. */
-(void)updateAsDisabled;

/** The background color that is applied to `inputElement` when this field view enters its disabled state.*/
@property (nonatomic, strong) UIColor *disabledInputElementBackgroundColor;

#pragma mark - Focused Appearance
/**@name Focused Appearance */

/** Style the field in it's focused look. */
-(void)updateAsFocused;

/** The border color that is applied to `inputElement` when this field view enters its focused state.*/
@property (nonatomic, strong) UIColor *focusedInputElementBorderColor;

#pragma mark - Syncing Views and Models
/** @name Syncing Views and Models*/

/** Updates `model` with the current contents of this view.
 
 Subclasses will typically implement this by pulling needed values from the `inputElement` or the `inputElement`'s `inputView`, doing any necessary formatting, and then setting this on the `model`'s `value`.
 
 It is unusual to need to call this method directly, as any user input into this field view automatically triggers this method. However it might be useful for subclassing/overridding in order to modify how this field view updates its model.
 */
- (void)updateModel;

/** Updates `inputElement`'s displayed value to match that of its `inputView`'s current state.
 
 Note that the `inputView` has to be capabable of persistent state in order for this method to do anything useful.
 
 It is unusual to need to call this method directly. However it might be useful for subclassing/overridding in order to modify how this field view updates its `inputElement` from the associated `inputView`.
 */
- (void)updateInputElementFromInputView;

@end
