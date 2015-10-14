//
//  SFormFieldLayoutLabelOnTopOfInput.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormFieldLayoutBase.h"

/** A field layout with the field's label placed above the input element.
 
 The label: The field's label will be placed at the top left. It will size to perfectly to fit the text within it, and it will be centered vertically within the field.
 
 The required label: The required label will be placed directly to the right of the label.
 
 The input element: The field's input element will be placed below the label, padding with the padding specified by `labelPadding`. Its width will span the remainder of the available space within the field's frame. It will have a height of `40`.
 
 The error label: The error label will be placed below the input element and will be inset to be inline with the text of the input element. It will be `20` pts high and span the rest of the field.
 
 <pre>
     __________  _
    |          ||_|
    |  Label   |
    |__________|
    |___________________________
    |                           |
    |  Input element            |
    |___________________________|
       |_________________________
       |_________________________|
 
 </pre>
 
 The default value for `labelPadding` is `2` points.
 */
@interface SFormFieldLayoutLabelOnTopOfInput : SFormFieldLayoutBase

@end
