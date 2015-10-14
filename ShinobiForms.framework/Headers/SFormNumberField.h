//
//  SFormNumberField.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import "SFormTextField.h"

/** A field for numeric entry.
  */
@interface SFormNumberField : SFormTextField

/** The value of the text field as a number. */
@property (nonatomic, strong) NSNumber *numberValue;

/** The number formatter responsible from converting `value` to `numberValue`. */
@property (nonatomic, strong) NSNumberFormatter *formatter;

@end
