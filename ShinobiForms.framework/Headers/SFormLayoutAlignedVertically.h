//
//  SFormVerticalLayout.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormLayout.h"

/** A layout manager that is used to layout sections in their superview so that:

 - The sections are left aligned.
 - The sections are stacked vertically in the order of the array (first element at top).
 - The sections keep their own size.
 
 <pre>
    |______________________________________
    |                                      |
    |              Section                 |
    |______________________________________|
    |
    |
    |_________________________
    |                         |
    |         Section         |
    |_________________________|
    |
    |
    |________________________________
    |                                |
    |              Section           |
    |________________________________|
    |
    |
 </pre>
 
 */

@interface SFormLayoutAlignedVertically : NSObject<SFormLayout>


/** The padding to be applied around the edge of the form.
 
 These `edgeInsets` will be taken into account when calculating the `idealSizeForFormView:` and calculating a section view's origin during layout. The form layout will not change section view sizes to respect these `edgeInsets`.
 */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/** The amount of vertical padding to be applied between section views. */
@property (nonatomic, assign) CGFloat verticalSpacing;

@end
