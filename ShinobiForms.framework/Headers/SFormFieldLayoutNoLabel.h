//
//  SFormFieldLayoutNoLabel.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <ShinobiForms/ShinobiForms.h>

/** A field layout with no field label.
 
 The label: The label will be given a frame of CGRectZero.
 
 The required label: The required label will be given a frame of CGRectZero.
 
 The input element: The field's input element will be placed at CGPointZero. Its width will span the remainder of the available space within the field's frame. It will have a height of `40`.
 
 The error label: The error label will be placed below the input element and will be inset to be inline with the text of the input element. It will be `20` pts in hight and its width will span the rest of the field.
 
 <pre>
    |___________________________
    |                           |
    |  Input element            |
    |___________________________|
    |
    |_________________________
    |_________________________|
 </pre>
 
 */
@interface SFormFieldLayoutNoLabel : SFormFieldLayoutBase

@end
