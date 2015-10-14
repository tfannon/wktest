//
//  SFormPickerFieldValidator.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import "SFormInvalidMessageProvider.h"
@class SFormPickerField;

/** This protocol provides an interface to be implemented by any object wanting to validate picker fields. */
@protocol SFormPickerFieldValidator <SFormInvalidMessageProvider>

/** Returns a `BOOL` value that indicates whether the picker field is valid.
 
 @param field The picker field to be validated.
 */
- (BOOL)validatePickerField:(SFormPickerField *)field;

@end
