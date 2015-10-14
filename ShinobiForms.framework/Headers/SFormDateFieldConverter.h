//
//  SFormDateFieldConverter.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormFieldModelViewConverter.h"

/** A converter that converts values between `SFormDateFieldView` view object and an `SFormDateField` model object.
 
 Behavior:
 
 Converts the field model value to an `NSString` representation so that a field view can display it in its input element.
 
 Converts the field view value to an `NSDate` representation so that it can be set on an `SFormDateField` instance.*/

@interface SFormDateFieldConverter : NSObject<SFormFieldModelViewConverter>

/**
 *  The locale that the converter will use when converting the date to a string. Defaults to `[NSLocale currentLocale]`,
 *  which is the current device's locale.
 */
@property (nonatomic, strong) NSLocale *locale;

@end
