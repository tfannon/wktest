//
//  SFormTextFieldConverter.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormFieldModelViewConverter.h"

/** A converter that converts values between `SFormTextFieldView` view object and an `SFormTextField` model object.
 
 Behavior:
 
 Converts the field model value to an `NSString` representation so that a field view can display it in its input element.
 
 Converts the field view value to an `NSString` representation so that it can be set on an `SFormTextField` instance.*/

@interface SFormTextFieldConverter : NSObject<SFormFieldModelViewConverter>

@end
