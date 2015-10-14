//
//  SFormFieldViewBuilder.h
//  ShinobiForms
//
//  Created by Jan Akerman on 09/12/2014.
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFormViewBuilder.h"

@class SFormField;
@class SFormFieldView;

/** An object capable of building an `SFormFieldView` subclass from an `SFormField` model object.
 */
@interface SFormFieldViewBuilder : NSObject <SFormViewBuilder>

/** Build an `SFormFieldView` from a `SFormField` model object.
 
 This method will return a correctly configured view for a given model object. The type of the model object given will
 depend on the type of the view returned:
 
 - `SFormTextField` - returns an `SFormTextFieldView`.
 - `SFormNumberField` - returns an `SFormTextFieldView`.
 - `SFormEmailField` - returns an `SFormEmailFieldView`.
 - `SFormChoiceField` - returns an `SFormSegmentedFieldView`.
 - `SFormRangedNumberField` - returns an `SFormSliderFieldView`.
 - `SFormDateField` - returns an `SFormDateFieldView`.
 - `SFormBooleanField` - return an `SFormSwitchFieldView`.
 
 This returned field view will be sized by calling `sizeToFit`.
 
 @param model The `SFormField` to build a view for.
 @return The `SFormFieldView` subclass created.
 */
-(SFormFieldView *)buildViewFromModel:(SFormField *)model;

@end
