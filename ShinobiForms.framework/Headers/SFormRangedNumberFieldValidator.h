//
//  SFormRangedNumberFieldValidator.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormInvalidMessageProvider.h"

@class SFormRangedNumberField;

/** This protocol provides an interface to be implemented by any object wanting 
 to validate ranged number fields.*/
@protocol SFormRangedNumberFieldValidator <SFormInvalidMessageProvider>

/** Returns a `BOOL` value that indicates whether the number field is valid.
 
 @param field The ranged number field to be validated.
 */
-(BOOL)validateRangedNumberField:(SFormRangedNumberField*)field;

@end
