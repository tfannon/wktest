//
//  SFormPickerField.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import "SFormField.h"

/** Represents the underlying model for a picker field.
 
 The `value` property of this class is an `NSArray` containing the indicies (represented as an `NSNumber`) of the selected components in the picker. There can be multiple incidies because a picker can have multiple columns.
 
 This class is compatible with validators that conform to `SFormPickerFieldValidator`.
 */
@interface SFormPickerField : SFormField

/** Create a picker field with the given options.
 
 This is the designated initializer.
 
 @param title The field's title.
 @param options The options to initialize the field with.
 */
-(instancetype)initWithTitle:(NSString *)title options:(NSArray *)options;

/** The current value of the field.

This is an array of `NSNumber` objects representing the index of each picker.
*/
@property (nonatomic, copy) NSArray *value;

/** An `NSArray` of `NSArray`s that contain the options for a picker.
 
 Each `NSArray` inside of the 'options' array should contain values to be displayed in the picker. These values can be either a `NSString`, or a `NSNumber`.
 */
@property (nonatomic, strong) NSArray *options;

@end
