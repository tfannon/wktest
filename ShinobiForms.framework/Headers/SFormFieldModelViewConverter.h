//
//  SFormFieldModelToViewConverter.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SFormField;
@class SFormFieldView;

/**
 Any object wishing to convert between `SFormField` objects and `SFormFieldView` objects should conform to this protocol.
 */

@protocol SFormFieldModelViewConverter <NSObject>

/** Responsible for pulling values from a field model and converting them to an appropriate format/type for a field view.
 
 @param fieldModel The field model that needs to have its value(s) converted.*/
- (id)viewValueFromModel:(SFormField*)fieldModel;

/** Responsible for pulling values from a field view and converting them to an appropriate format/type for a field model.
 
 @param fieldView The field view that needs to have its value(s) converted.*/
- (id)modelValueFromView:(SFormFieldView*)fieldView;

@end
