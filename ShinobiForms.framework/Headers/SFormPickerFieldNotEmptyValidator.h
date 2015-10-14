//
//  SFormPickerFieldNotEmptyValidator.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import "SFormPickerFieldValidator.h"

/** This validator checks to see if the picker field is empty.
 
 This works by checking to see if the field's value is nil. If this is the case then the field is invalid. If otherwise, the field is valid.
 */
@interface SFormPickerFieldNotEmptyValidator : NSObject <SFormPickerFieldValidator>

/** A string representing the invalid message to provide. */
@property (nonatomic, strong) NSString *invalidMessage;

@end
