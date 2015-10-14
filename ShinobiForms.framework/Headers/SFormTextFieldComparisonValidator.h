//
//  SFormTextFieldComparisonValidator.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormTextFieldValidator.h"
#import "SFormComparisonRule.h"
#import "SFormTextComparisonMode.h"

@class SFormTextField;

/** A validator that compares the validating text field's input against a specified text field's input. */
@interface SFormTextFieldComparisonValidator : NSObject<SFormTextFieldValidator>

/** A string representing the invalid message to provide. */
@property (nonatomic, strong) NSString *invalidMessage;

/** The text field that we are comparing the validating text field's input against. */
@property (nonatomic, readonly, retain) SFormTextField *toCompare;

/** The result needed from the comparison to achieve positive validation. */
@property (nonatomic, readonly, assign) SFormComparisonRule validResult;

/** How to treat the value of the text field for the comparison.
 
 A value of `SFormTextComparisonModeTextValue` will compare the contents of the fields as `NSString`s.
 A value of `SFormTextComparisonModeNumberValue` will compare the contents of the fields as `NSNumber`s. If either field's values can not be converted successfully to an `NSNumber`, validation will return `NO`.
 */
@property (nonatomic, assign) SFormTextComparisonMode comparisonMode;

/** Returns an instance of this class that will compare the validating text field's input against the input a provided text field.
 
 This validator calls the `compare:` method on the field's `value` property, passing in the `toCompare` field's `value` as the parameter. This validator will validate positively if the comparison result is the same as the valid result provided.
 
 @param toCompare The text field whose input will be compare with the validating text field's input.
 @param validResult The comparison result that trigger provide positive validation.
 */
- (instancetype)initWithFieldToCompare:(SFormTextField *)toCompare validResult:(SFormComparisonRule)validResult;

@end
