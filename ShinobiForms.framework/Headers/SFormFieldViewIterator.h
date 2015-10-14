//
//  SFormFieldViewIterator.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFormFieldView;

/** An object capable of iterating over an array of fields.
 */
@protocol SFormFieldViewIterator <NSObject>

/** The field previous to the given field.
 
 Nil will be returned if there is no field previous from this field.
 
 @warning This method assumes that `fieldView` belongs to one of the given sections in the `sectionViews` array.
 
 @param fieldView The field view we are iterating from.
 @param sectionViews An array of `SFormSectionView` objects containing the given `fieldView`.
 @return The field view previous to the given `fieldView`.
 */
-(SFormFieldView *)previousToFieldView:(SFormFieldView *)fieldView inSectionViews:(NSArray *)sectionViews;

/** The field next to the given field.
 
 Nil will be returned if there is no field next from this field.
 
 @warning This method assumes that `fieldView` belongs to one of the given sections in the `sectionViews` array.
 
 @param fieldView The field view we are iterating from.
 @param sectionViews An array of `SFormSectionView` objects containing the given `fieldView`.
 @return The field view next to the given `fieldView`.
 */
-(SFormFieldView *)nextToFieldView:(SFormFieldView *)fieldView inSectionViews:(NSArray *)sectionViews;

@end
