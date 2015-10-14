//
//  SFormBooleanFieldConverter.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormFieldModelViewConverter.h"

/** A converter that converts values between `SFormSwitchFieldView` view object and a `SFormBooleanField` model object.
 
 Behavior:
 
 Converts the field model value to an `NSNumber` representation so that a field view can display it in its input element.
 
 Converts the field view value to an `NSNumber` representation so that it can be set on an `SFormBooleanField` instance.*/

@interface SFormBooleanFieldConverter : NSObject<SFormFieldModelViewConverter>

@end
