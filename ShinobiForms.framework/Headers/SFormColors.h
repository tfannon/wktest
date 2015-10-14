//
//  SFormColors.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This is a util class that contains all the colors that are used as defaults in the ShinobiForms framework.
 */
@interface SFormColors : NSObject

#pragma mark - Label Colors
/** @name Label Colors */

/** The default text color used for the `label` on an `SFormFieldView` instance. */
+(UIColor *)labelTextColor;

/** The default text color used for the `requiredLabel` on an `SFormFieldView` instance. */
+(UIColor *)requiredLabelTextColor;

/** The default text color used for the `errorLabel` on an `SFormFieldView` instance. */
+(UIColor *)errorLabelTextColor;

#pragma mark - Input Element Colors
/** @name Input Element Colors */

/** The default text color used for the `inputElement` text on an `SFormFieldView` instance. */
+(UIColor *)inputTextColor;

/** The default tint color used for the `inputElement` text on an `SFormFieldView` instance. */
+(UIColor *)inputTintColor;

/** The default background color used for the `inputElement`'s default state in an `SFormFieldView` instance. */
+(UIColor *)inputDefaultBackgroundColor;

/** The default background color used for the `inputElement`'s disabled state in an `SFormFieldView` instance. */
+(UIColor *)inputDisabledBackgroundColor;

/** The default border color used for the input `inputElement`'s default state in an `SFormFieldView` instance. */
+(UIColor *)inputDefaultBorderColor;

/** The default border color used for the `inputElement`'s disabled state in an `SFormFieldView` instance. */
+(UIColor *)inputDisabledBorderColor;

/** The default border color used for the `inputElement`'s valid state in an `SFormFieldView` instance. */
+(UIColor *)inputValidBorderColor;

/** The default border color used for the `inputElement`'s invalid state in an `SFormFieldView` instance. */
+(UIColor *)inputInvalidBorderColor;

/** The default border color used for the `inputElement`'s focused state in an `SFormFieldView` instance. */
+(UIColor *)inputFocusBorderColor;

#pragma mark - Toolbar Colors
/** @name Toolbar Colors */

/** The default color used for the navigation arrows on an `SFormToolbar` instance.*/
+(UIColor *)arrowColor;

/** The default color used for the navigation arrows in their highlighted state on an `SFormToolbar` instance. */
+(UIColor *)arrowHighlightedColor;

/** The default color used for the navigation arrows in their disabled state on an `SFormToolbar` instance. */
+(UIColor *)arrowDisabledColor;

#pragma mark - Submit Button Colors
/** @name Submit Button Colors */

/** The default color used for the title of an `SFormSubmitButton` instance. */
+(UIColor *)submitTitleColor;

/** The default color used for the background of an `SFormSubmitButton` instance in its default state. */
+(UIColor *)submitBackgroundColor;

/** The default color used for the background of an `SFormSubmitButton` instance in its highlighted state. */
+(UIColor *)submitHighlightedBackgroundColor;

@end
