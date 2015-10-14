//
//  SFormBooleanFieldValidator.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import "SFormInvalidMessageProvider.h"
@class SFormBooleanField;

/** This protocol provides an interface to be implemented by any object wanting to validate boolean fields.
 */
@protocol SFormBooleanFieldValidator <SFormInvalidMessageProvider>

/** Returns a `BOOL` value that indicates whether the boolean field is valid.

 @param field The boolean field to be validated.
 */
- (BOOL)validateBooleanField:(SFormBooleanField *)field;

@end
