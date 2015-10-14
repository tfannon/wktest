//
//  SFormNumberFieldConverter.h
//  ShinobiForms
//
//  Created by Ryan Grey on 28/01/2015.
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormFieldModelViewConverter.h"

/** A converter that converts values between `SFormTextFieldView` view object and an `SFormNumberField` model object.
 
 Behavior:
 
 Converts the field model value to an `NSString` representation so that a field view can display it in its input element.
 
 Converts the field view value to an `NSString representation so that it can be set on an `SFormNumberField` instance.
 
 Conversion in both directions strips out non numeric characters and adds grouping seperators.
 */

@interface SFormNumberFieldConverter : NSObject<SFormFieldModelViewConverter>

/** The grouping seperator used to format the numeric string. */
@property (nonatomic, strong) NSString *groupingSeperator;

/** The decimal seperator used to format the numeric string. */
@property (nonatomic, strong) NSString *decimalSeperator;

/** The negative symbol used to indicate negative numbers.
 
 This will be shown at the beginning of the number.
 */
@property (nonatomic, strong) NSString *negativeSymbol;

@end
