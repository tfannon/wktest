//
//  SFormChoiceFieldComparisonValidator.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormChoiceFieldValidator.h"
#import "SFormComparisonRule.h"

@class SFormChoiceField;

/** A validator that compares the validating choice field's input against a specified choice field's input. */
@interface SFormChoiceFieldComparisonValidator : NSObject<SFormChoiceFieldValidator>

/** A string representing the invalid message to provide. */
@property (nonatomic, strong) NSString *invalidMessage;

/** The choice field that we are comparing the validating choice field's input against. */
@property (nonatomic, readonly, retain) SFormChoiceField *toCompare;

/** The result needed from the comparison to achieve positive validation. */
@property (nonatomic, readonly, assign) SFormComparisonRule validResult;

/** Returns an instance of this class that will compare the validating choice field's input against the input of a provided choice field.
 
 This validator calls the `compare:` method on the field's `value` property, passing in the `toCompare` field's `value` as the parameter. This validator will validate positively if the comparison result is the same as the valid result provided.
 
 @param toCompare The choice field whose input will be compare with the validating choice field's input.
 @param validResult The comparison result that trigger provide positive validation.
 */
- (instancetype)initWithFieldToCompare:(SFormChoiceField *)toCompare validResult:(SFormComparisonRule)validResult;

@end
