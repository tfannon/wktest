//
//  SFormTextFieldNumericValidator.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormTextFIeldValidator.h"

/** A validator to check that a text field has a valid numeric string value.
 
 This allows for strings including:
 
 - Integer values E.g. `12345`
 - Decimal values E.g. `123.45` (unless `allowDecimalValues` is `NO`).
 - Thousand-separated values E.g. `12,345`
 - Negative values E.g. `-12345`
 
 Empty strings are also valid. Use the `SFormTextFieldNotEmptyValidator` to mark these as invalid.
 */

@interface SFormTextFieldNumericValidator : NSObject<SFormTextFieldValidator>

/** Designated initializer for creating a validator for a given locale. Otherwise, defaults to using [NSLocale systemLocale].
 
 The locale controls the thousands separator that is considered to be valid by the returned validator.
 */
-(id)initWithLocale:(NSLocale*)locale;

/** A string representing the invalid message to provide. */
@property (nonatomic, strong) NSString *invalidMessage;

/** Whether values with a fractional part are valid (such as `123.45`).
 
 Defaults to `YES`.
 */
@property (nonatomic, assign) BOOL allowDecimalValues;

/** Whether to treat numeric strings as whole strings when validating, or to allow partial strings.
 
 E.g. `1,000,0` could be entered as a partial string when trying to type `1,000,000`.
 When `allowPartialStrings` is `YES`, `1,000,0` would be valid, as it is possible to add more digits to create a valid number.
 When `allowPartialStrings` is `NO`, `1,000,0` would be invalid.
 Normal validation will still be run, so `1,000,0000` would be invalid in both cases, as it is not possible to keep adding digits to create a valid number.
 
 Defaults to `NO`, to treat all numeric strings as fully-formed numbers.
 */
@property (nonatomic, assign) BOOL allowPartialStrings;

@end
