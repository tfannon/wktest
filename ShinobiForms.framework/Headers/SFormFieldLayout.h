//
//  SFormFieldLayout.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SFormFieldView;

/** An object capable of laying out the contents of an `SFormFieldView`.
 
 Possible implementations include:
 
 - `SFormFieldLayoutLabelOnTopOfInput`: Positions the label of the field above the input element, with some padding inbetween (default).
 - `SFormFieldLayoutLabelLeftOfInput`: Positions the label of the field to the left of the input element, with some padding between.
 - `SFormFieldLayoutNoLabel`: Hides the field's label.
 */
@protocol SFormFieldLayout <NSObject>

/** The ideal size for a field in this layout.
 
 This method should calculate and return the ideal size for the field view.
 
 @param fieldView the field view to be sized.
 @return The ideal size for the field.
 */
+(CGSize)idealSizeForFieldView:(SFormFieldView *)fieldView;

/** Lays out the contents of the field view.
 
 @param fieldView The field view to be laid out.
 */
-(void)layout:(SFormFieldView*)fieldView;

/** The amount of padding between the required label and the input element of a field. */
@property (nonatomic, assign) CGFloat labelPadding;

@end
