//
//  SFormBooleanFieldFalseValidator.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormBooleanFieldValidator.h"

/** This validator checks to see if the boolean field's value is false.

 If the field value is false, then the field is valid, and invalid otherwise.
 */
@interface SFormBooleanFieldFalseValidator : NSObject <SFormBooleanFieldValidator>

/** A string representing the invalid message to provide. */
@property (nonatomic, strong) NSString *invalidMessage;


@end
