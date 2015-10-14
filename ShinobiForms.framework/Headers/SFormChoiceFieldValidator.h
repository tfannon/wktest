//
//  SFormStringValidator.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormInvalidMessageProvider.h"

@class SFormChoiceField;

/** This protocol provides an interface to be implemented by any object wanting to validate choice fields. */
@protocol SFormChoiceFieldValidator <SFormInvalidMessageProvider>

/** Returns a `BOOL` value that indicates whether the choice field is valid.
 
 @param field The choice field to be validated.
 */
-(BOOL)validateChoiceField:(SFormChoiceField*)field;

@end
