//
//  SFormTextField.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import "SFormField.h"

/** A field for text entry. 
  
 The text field returns an `NSString` as it's field value.
 
 This class is compatible with validators that conform to `SFormTextFieldValidator`.
 */
@interface SFormTextField : SFormField

/** The current value of the field.
 */
@property (nonatomic, copy) NSString *value;

@end
