//
//  SFormRangedNumberField.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import "SFormNumberField.h"

/** A field for numeric entry within a set range.
 
 This class represents a field model where a number can be chosen within a given maximum & minimum. This specializes the `SFormNumberField` to limit the setting of the `value` within a given bounds.
 
 This class is compatible with validators that conform to `SFormRangedNumberFieldValidator`.
 */
@interface SFormRangedNumberField : SFormField

/** Create a ranged number field with the given title and a given range.
 
 This is the designated initializer.
 
 @param title The field's title.
 @param minimum The minimum of the field's range.
 @param maximum The maximum of the field's range.
 */
-(instancetype)initWithTitle:(NSString *)title minimum:(NSNumber *)minimum maximum:(NSNumber *)maximum;

/** The current value of the field. */
@property (nonatomic, copy) NSNumber *value;

/** The minimum value this field can store. */
@property (nonatomic, strong) NSNumber *minimum;

/** The maxium value this field can store. */
@property (nonatomic, strong) NSNumber *maximum;

@end
