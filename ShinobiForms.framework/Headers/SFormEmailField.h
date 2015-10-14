//
//  SFormEmailField.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormTextField.h"

/** A field for inputting email addresses.
 
 The field uses an email validator (`SFormTextFieldEmailValidator`).
 
 The email field returns an `NSString` as it's field value.
 */
@interface SFormEmailField : SFormTextField

@end
