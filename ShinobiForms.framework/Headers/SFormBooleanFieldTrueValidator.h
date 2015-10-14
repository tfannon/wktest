//
//  SFormBooleanFieldTrueValidator.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormBooleanFieldValidator.h"

/** This validator checks to see if the boolean field's value is true.

 If the field value is true, then the field is valid, and invalid otherwise.
 */
@interface SFormBooleanFieldTrueValidator : NSObject <SFormBooleanFieldValidator>

/** A string representing the invalid message to provide. */
@property (nonatomic, strong) NSString *invalidMessage;

@end
