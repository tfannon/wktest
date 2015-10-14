//
//  SFormPickerFieldConverter.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormFieldModelViewConverter.h"

/** A converter that converts values between `SFormPickerFieldView` view object and an `SFormPickerField` model object.
 
 Behavior:
 
 Converts the field model value to an `NSString` representation so that a field view can display it in its input element.
 
 Converts the field view value to an `NSArray` representing selected indices so that it can be set on an `SFormPickerField` instance.*/

@interface SFormPickerFieldConverter : NSObject<SFormFieldModelViewConverter>

@end
