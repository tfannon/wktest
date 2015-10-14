//
//  SFormNumberFieldValidators.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormComparisonRule.h"

@class SFormRangedNumberField;
@class SFormRangedNumberFieldComparisonValidator;
@class SFormFieldGroup;

/** A utility class that provides helper methods for some common number field validator types. */
@interface SFormRangedNumberFieldValidators : NSObject

/** @name Ranged Number Field Validation*/

/** Returns a validator that compares the validating number field's input against a specified number field's input.
 
 @param field The field the validator will compare against.
 @param expectedResult The comparison result required to pass validation.
 */
+(SFormRangedNumberFieldComparisonValidator *)compareWithRangedNumberField:(SFormRangedNumberField *)field validResult:(SFormComparisonRule)expectedResult;

/** Sets up a relationship between a minimum number field and a maximum number field on a form.
 
 This helper does the following:
 - Adds an `SFormNumberFieldComparisonValidator` to `minField` with `SFormComparisonRuleLessThan` as the expected result.
 - Adds an `SFormNumberFieldComparisonValidator` to `maxField` with `SFormComparisonRuleGreaterThan` as the expected result.
 - Adds both fields to a new `SFormValidationGroup` and returns the group.
 
 @warning You need to store a strong reference to the returned `SFormFieldGroup`.
 
 @param form The form the fields belong to.
 @param minField The minimum field.
 @param maxField The maximum field.
 */
+(SFormFieldGroup*)minMaxGroupForMinRangedNumberField:(SFormRangedNumberField *)minField maxRangedNumberField:(SFormRangedNumberField *)maxField;

@end
