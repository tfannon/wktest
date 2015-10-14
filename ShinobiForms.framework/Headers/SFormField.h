//
//  SFormField.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

/** A field for data entry.
 
 An `SFormField` is a model object of a field.

 Fields can have validators to verify input. See `validators` for more details.
 
 There are various field model types available:
 
 - `SFormTextField`: A field model with a NSString `value`.
 - `SFormEmailField`: A field model with an NSString `value` and an `SFormEmailValidator`.
 - `SFormNumberField`: A field model with a NSNumber `value`.
 - `SFormRangedNumberField`: A field with an `NSNumber` `value` limited between a minimum and a maximum.
 - `SFormBooleanField`: A field model with a YES, NO decision represented as an `NSNumber` `value`.
 - `SFormChoiceField`: A field model with a set of options, representing a choice as an `NSNumber` index.
 - `SFormPickerField`: A field model allowing multiple sets of options, representing a choice in a given set of options with as an `NSNumber` index.
 - `SFormDateField`: A field model with an NSDate `value`.
 */
@interface SFormField : NSObject

/** Create a field with the given title.

 This is the designated initializer.
 
 @param title The field's title.
 */
-(instancetype)initWithTitle:(NSString *)title;

#pragma mark - Identifying a Field

/** @name Identifying a Field */

/** The title of this field. */
@property (nonatomic, retain) NSString *title;

#pragma mark - Value
/** @name Value */

/** The current value of the field.
 
 The type of this property will depend upon the type of field you have chosen. Check the relevant field's documentation for more information.
 */
@property (nonatomic, copy) id value;

#pragma mark - Validation
/** @name Validation */

/** An array of validators to be ran when `value` is updated.
 
 Each element must adopt the validator protocol appropriate to the field type in question. For example an `SFormTextField`'s validators must conform to the `SFormTextFieldValidator` protocol.
 
 @warning When updating the validators, they will run instantly to verify the currect `value`.
 */
@property (nonatomic, copy) NSArray *validators;

/** Whether the field is currently valid. */
@property (nonatomic, assign, readonly) BOOL isValid;

/** The currently failing validators on the field.
 
 This array contains an array of objects conforming to `SFormInvalidMessageProvider`.
 */
@property (nonatomic, strong, readonly) NSArray *currentlyFailingValidators;

/** Whether this field is required.
 
 If a field is required, a validator ensuring that the field is not empty will be added to the validaor array.
 
 This defaults to `NO`.
 */
@property (nonatomic, assign) BOOL required;

@end
