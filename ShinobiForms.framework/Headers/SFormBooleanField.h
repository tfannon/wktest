//
//  SFormBooleanField.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import "SFormField.h"

/** Represents the underlying model for a boolean field.

 The boolean field returns an `NSNumber` as it's field value representing the boolean value. Call `boolValue` to get the
 value as a `BOOL`.
 
 This class is compatible with validators that conform to `SFormBooleanFieldValidator`.
 */
@interface SFormBooleanField : SFormField

/** The current value of the field.
 */
@property (nonatomic, copy) NSNumber *value;

@end
