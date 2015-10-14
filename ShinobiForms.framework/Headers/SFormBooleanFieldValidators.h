//
//  SFormBooleanFieldValidators.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import "SFormComparisonRule.h"

@class SFormBooleanField;
@class SFormBooleanFieldTrueValidator;
@class SFormBooleanFieldFalseValidator;
@class SFormBooleanFieldComparisonValidator;

/** A utility class that provides helper methods for some common boolean field validator types. */
@interface SFormBooleanFieldValidators : NSObject

/** Creates a true validator to use with a boolean field.
 
 @return A validator asserting that a boolean field's value is true.
 */
+ (SFormBooleanFieldTrueValidator *)trueValidator;

/** Creates a true validator to use with a boolean field.
 
 @return A validator asserting that a boolean field's value is false.
 */
+ (SFormBooleanFieldTrueValidator *)falseValidator;

/** Creates a validator which compares the validating boolean field's input against a specified boolean field's input.

 @param field          The boolean field that the validator will compare against.
 @param expectedResult The comparison result required for this validator to pass validation.

 @return A validator to use with a boolean field that compares it with another speicifed field.
 */
+ (SFormBooleanFieldComparisonValidator *)compareWithBooleanField:(SFormBooleanField *)field
                                                      validResult:(SFormComparisonRule)expectedResult;

@end
