//
//  SFormRangedNumberFieldComparisonValidator.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormRangedNumberFieldValidator.h"
#import "SFormComparisonRule.h"

@class SFormRangedNumberField;

/** A validator that compares the validating number field's input against a specified number field's input.
 */
@interface SFormRangedNumberFieldComparisonValidator : NSObject<SFormRangedNumberFieldValidator>

/** A string representing the invalid message to provide. */
@property (nonatomic, strong) NSString *invalidMessage;

/** The number field that we are comparing the validating number field's input against. */
@property (nonatomic, readonly, retain) SFormRangedNumberField *toCompare;

/** The result needed from the comparison to achieve positive validation. */
@property (nonatomic, readonly, assign) SFormComparisonRule validResult;

/** Returns an instance of this class that will compare the validating number field's input against the input of a provided number field.
 
 This validator calls the `compare:` method on the field's `value` property, passing in the `toCompare` field's `value` as the parameter. This validator will validate positively if the comparison result is the same as the valid result provided.
 
 @param toCompare The number field whose input will be compare with the validating number field's input.
 @param validResult The comparison result that trigger provide positive validation.
 */
- (instancetype)initWithFieldToCompare:(SFormRangedNumberField *)toCompare validResult:(SFormComparisonRule)validResult;

@end
