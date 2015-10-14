//
//  SFormTextFieldRegexValidator.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormTextFieldValidator.h"

/** A validator to check a text field's text against a regular expression. */
@interface SFormTextFieldRegexValidator : NSObject<SFormTextFieldValidator>

/** A string representing the invalid message to provide. */
@property (nonatomic, strong) NSString *invalidMessage;

/** The regex string the validator will validate against. */
@property (nonatomic, strong, readonly) NSString *regexString;

/** Create the validator to verify using an `NSRegularExpression`. */
-(id)initWithRegularExpression:(NSRegularExpression*)regularExpression;

/** Create the validator to verify using a regex string.
 
 By default, this will match againt partial strings.
 To specify that the entire string must match the regex, use the `^` (beginning of line) and `$` (end of line) characters at either end of the string.
 */
-(id)initWithRegexString:(NSString*)regexString;

@end
