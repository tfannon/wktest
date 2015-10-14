//
//  SFormSectionLayoutAlignedVertically.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import "SFormSectionBaseLayout.h"

/** A layout manager that is used to layout fields in their superview so that:

 - The fields are left aligned.
 - The fields are stacked vertically in the order of the array (first element at top).
 - The fields keep their own size.

 <pre>
    |_______________________________________
    |                     | |               |
    | Very long label     | |     field     |
    |____________________ |_|_______________|
    |
    |
    |_____________________________
    |             | |             |
    | label       | |   field     |
    |_____________|_|_____________|
    |
    |
    |______________________________________
    |                  | |                 |
    | long label       | |  field          |
    |__________________|_|_________________|
    |
    |
    Aligned
 
 </pre>

 */
@interface SFormSectionLayoutAlignedVertically : SFormSectionBaseLayout

@end
