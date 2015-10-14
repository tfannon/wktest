//
//  SFormValidators.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFormComparisonRule.h"
#import "SFormTextComparisonMode.h"

@class SFormTextField;
@class SFormTextFieldNotEmptyValidator;
@class SFormTextFieldNumericValidator;
@class SFormTextFieldEmailValidator;
@class SFormTextFieldComparisonValidator;
@class SFormFieldGroup;

/** A utility class that provides helper methods for some common text field validator types.*/
@interface SFormTextFieldValidators : NSObject

/** @name Text Field Validation*/

/** Returns a validator asserting that a text field has non-empty content. */
+(SFormTextFieldNotEmptyValidator *)notEmpty;

/** Returns a validator to check that a text field contains a valid numeric string. */
+(SFormTextFieldNumericValidator *)numeric;

/** Returns a validator to check that a text field contains a valid email address. E.g. info@shinobicontrols.com. */
+(SFormTextFieldEmailValidator *)email;

/** Returns a validator that compares the validating text field's input against a specified text field's input.
 
 @param field The field the validator will compare against.
 @param expectedResult The comparison result required to pass validation.
 @param comparisonMode An option representing how to interpret the text as a value for comparison.
 */
+(SFormTextFieldComparisonValidator *)compareWithTextField:(SFormTextField *)field comparisonMode:(SFormTextComparisonMode)comparisonMode validResult:(SFormComparisonRule)validResult;

/** Sets up a relationship between a minimum text field and a maximum text field on a form.
 
 This helper does the following:
 - Adds an `SFormTextFieldComparisonValidator` to `minField` with `SFormComparisonRuleLessThan` as the expected result.
 - Adds an `SFormTextFieldComparisonValidator` to `maxField` with `SFormComparisonRuleGreaterThan` as the expected result.
 - Adds both fields to a new `SFormValidationGroup` and returns the group.
 
 @warning You need to store a strong reference to the returned `SFormFieldGroup`.
 
 @param minField The minimum field.
 @param maxField The maximum field.
 param comparisonMode An option representing how to interpret the text as a value for comparison.
 */
+(SFormFieldGroup*)minMaxGroupForMinTextField:(SFormTextField *)minField maxTextField:(SFormTextField *)maxField comparisonMode:(SFormTextComparisonMode)comparisonMode;

@end
