//
//  SFormSectionLayoutAlignedVerticallyByInput.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import "SFormSectionBaseLayout.h"

/** A layout manager that is used to layout fields in their superview so that:

 - The fields are aligned by their input elements.
 - The fields are stacked vertically in the order of the array (first element at top).
 - The fields keep their own size.
 
 <pre>
     _______________________________________
    |                     | |               |
    |     Very long label | |     field     |
    |_____________________|_|_______________|
                            |
                            |
                ____________|_____________
               |          | |             |
               |    label | |   field     |
               |__________|_|_____________|
                            |
                            |
            ________________|_________________
           |              | |                 |
           |   long label | |  field          |
           |______________|_|_________________|
                            |
                            |
                         Aligned
 </pre>
 
 This layout will force a `layoutSubviews` on the section's field views.

 */
@interface SFormSectionLayoutAlignedVerticallyByInput : SFormSectionBaseLayout

@end
