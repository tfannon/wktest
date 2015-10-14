//
//  SFormChoiceFieldValidators.h
//  ShinobiForms
//
//  Created by Ryan Grey on 29/11/2014.
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormComparisonRule.h"

@class SFormChoiceField;
@class SFormChoiceFieldNotEmptyValidator;
@class SFormChoiceFieldComparisonValidator;
@class SFormFieldGroup;

/** A utility class that provides helper methods for some common choice field validator types. */
@interface SFormChoiceFieldValidators : NSObject

/** @name Choice Field Validation*/

/** Returns a validator asserting that a choice field has non-empty content. */
+(SFormChoiceFieldNotEmptyValidator *)notEmpty;

/** Returns a validator that compares the validating choice field's input against a specified choice field's input.
 
 @param field The field the validator will compare against.
 @param expectedResult The comparison result required to pass validation.
 */
+(SFormChoiceFieldComparisonValidator *)compareWithChoiceField:(SFormChoiceField *)field validResult:(SFormComparisonRule)expectedResult;

/** Sets up a relationship between a minimum choice field and a maximum choice field on a form.
 
 This helper does the following:
 - Adds an `SFormChoiceFieldComparisonValidator` to `minField` with `SFormComparisonRuleLessThan` as the expected result.
 - Adds an `SFormChoiceFieldComparisonValidator` to `maxField` with `SFormComparisonRuleGreaterThan` as the expected result.
 - Adds both fields to a new `SFormValidationGroup` and returns the group.
 
 @warning You need to store a strong reference to the returned `SFormFieldGroup`.
 
 @param form The form the fields belong to.
 @param minField The minimum field.
 @param maxField The maximum field.
 */
+(SFormFieldGroup*)minMaxGroupForMinChoiceField:(SFormChoiceField *)minField maxChoiceField:(SFormChoiceField *)maxField;

@end
