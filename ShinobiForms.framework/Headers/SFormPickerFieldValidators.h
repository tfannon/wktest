//
//  SFormPickerFieldValidators.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

@class SFormPickerField;
@class SFormPickerFieldNotEmptyValidator;

/** A utility class that provides helper methods for some common picker field validator types.*/
@interface SFormPickerFieldValidators : NSObject

/** Returns a validator asserting that a picker field has non-empty content. */
+ (SFormPickerFieldNotEmptyValidator *)notEmpty;

@end
