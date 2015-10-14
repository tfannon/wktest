//
//  SFormDateField.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <ShinobiForms/ShinobiForms.h>

/** Represents the underlying model for a date field.
 
 The `value` property of this class is an `NSDate`.
 
 This class is compatible with validators that conform to `SFormDateFieldValidator`.
*/

@interface SFormDateField : SFormField

/** The current value of the field.
 */
@property (nonatomic, copy) NSDate *value;

@end
