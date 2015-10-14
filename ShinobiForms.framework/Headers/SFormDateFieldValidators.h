//
//  SFormDateFieldValidators.h
//  ShinobiForms
//
//  Created by Jan Akerman on 24/12/2014.
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormComparisonRule.h"

@class SFormDateField;
@class SFormDateFieldNotEmptyValidator;
@class SFormDateFieldComparisonValidator;
@class SFormFieldGroup;

/** A utility class that provides helper methods for some common date field validator types. */
@interface SFormDateFieldValidators : NSObject

/** @name Date Field Validation*/

/** Returns a validator asserting that a date field has non-empty content. */
+(SFormDateFieldNotEmptyValidator *)notEmpty;

/** Returns a validator that compares the validating date field's input against a specified date field's input.
 
 @param field The field the validator will compare against.
 @param expectedResult The comparison result required to pass validation.
 */
+(SFormDateFieldComparisonValidator *)compareWithDateField:(SFormDateField *)field validResult:(SFormComparisonRule)validResult;

/** Sets up a relationship between a minimum date field and a maximum date field on a form.
 
 This helper does the following:
 - Adds an `SFormDateFieldComparisonValidator` to `minField` with `SFormComparisonRuleLessThan` as the expected result.
 - Adds an `SFormDateFieldComparisonValidator` to `maxField` with `SFormComparisonRuleGreaterThan` as the expected result.
 - Adds both fields to a new `SFormValidationGroup` and returns the group.
 
 @warning You need to store a strong reference to the returned `SFormFieldGroup`.
 
 @param form The form the fields belong to.
 @param minField The minimum field.
 @param maxField The maximum field.
 */
+(SFormFieldGroup*)minMaxGroupForMinDateField:(SFormDateField *)minField maxDateField:(SFormDateField *)maxField;

@end
