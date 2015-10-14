//
//  SFormStringValidator.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormInvalidMessageProvider.h"

@class SFormTextField;

/** This protocol provides an interface to be implemented by any object wanting to validate text fields. */
@protocol SFormTextFieldValidator <SFormInvalidMessageProvider>

/** Returns a `BOOL` value that indicates whether the text field is valid.
 
 @param field The text field to be validated.
 */
-(BOOL)validateTextField:(SFormTextField*)field;

@end
