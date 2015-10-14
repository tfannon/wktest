//
//  SFormTextFieldEmailValidator.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormTextFIeldValidator.h"

/** A validator to check a text field's text is valid email. */
@interface SFormTextFieldEmailValidator : NSObject<SFormTextFieldValidator>

/** A string representing the invalid message to provide. */
@property (nonatomic, strong) NSString *invalidMessage;

@end
