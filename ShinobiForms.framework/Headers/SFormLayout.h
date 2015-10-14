//
//  SFormLayout.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SFormView;

/** A object capable of laying out the contents of a `ShinobiForm`.
 
 Possible implementations include:
 
 - `SFormLayoutAlignedVertically`: Positions sections vertically, aligned by their left edges (default).
 */
@protocol SFormLayout <NSObject>

/** Positions sections within the form.

 A typical implementation of this would iterate through the section views and
 modify the frame of each one so they are appropriately positioned.

 @param formView The form view we are positioning the sections within.
 @param sectionViews An array of section views to be positioned.
 */
- (void)layout:(SFormView *)formView sectionViews:(NSArray *)sectionViews;

/** The ideal size for a form in this layout.
 
 This method should calculate and return the ideal size for the form view.
 
 @param formView The form view.
 @return The ideal size for the form view.
 */
-(CGSize)idealSizeForFormView:(SFormView *)formView;

@end
