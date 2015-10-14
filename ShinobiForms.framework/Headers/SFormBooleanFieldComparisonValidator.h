//
//  SFormBooleanFieldComparisonValidator.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import "SFormBooleanFieldValidator.h"
#import "SFormComparisonRule.h"
@class SFormBooleanField;

/** A validator that compares the validating boolean field's input against a specified boolean field's input.
 */
@interface SFormBooleanFieldComparisonValidator : NSObject<SFormBooleanFieldValidator>

/** A string representing the invalid message to provide. */
@property (nonatomic, strong) NSString *invalidMessage;

/** The boolean field that we are comparing the validating boolean field's input against.
 */
@property (nonatomic, readonly, retain) SFormBooleanField *toCompare;

/** The result needed from the comparison to achieve positive validation.
 */
@property (nonatomic, readonly, assign) SFormComparisonRule validResult;

/** Returns an instance of this class that will compare the validating boolean field's input against the input of a provided boolean field.

 This validator calls the `compare:` method on the field's `value` property, passing in the `toCompare` field's `value` as the parameter. This validator will validate positively if the comparison result is the same as the valid result provided.

 @param toCompare The boolean field whose input will be compare with the validating boolean field's input.
 @param validResult The comparison result that trigger provide positive validation.
 */
- (instancetype)initWithFieldToCompare:(SFormBooleanField *)toCompare validResult:(SFormComparisonRule)validResult;

@end
