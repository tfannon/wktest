//
//  SFormChoiceField.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import "SFormField.h"

/** A field for choosing from set of options. 
 
 This class represents a field model where multiple choices are available, but only one choice may be selected by the user. For example, a "Gender" field that provides the choices "Male" and "Female".
 
 This field type returns an `NSNumber` as its field value representing the index (in `choices`) of the currently selected choice.
 
 This class is compatible with validators that conform to `SFormChoiceFieldValidator`.
 */
@interface SFormChoiceField : SFormField

/** Create a choice field with the given title and choices.
 
 This is the designated initializer.
 
 @param title The field's title.
 @param choices The choices that should be presented to the user via `view`.
 */
-(instancetype)initWithTitle:(NSString *)title choices:(NSArray *)choices;

/** The current value of the field.
 
 This is the index of the currently selected option.
 */
@property (nonatomic, copy) NSNumber *value;

/** The choices that should be presented to the user via `view`.
 
 This should be an array of `NSString` or `UIImage` objects.
 */
@property (nonatomic, strong) NSArray *choices;

@end
