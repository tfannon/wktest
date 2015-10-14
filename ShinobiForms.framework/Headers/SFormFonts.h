//
//  SFormFonts.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This is a util class that contains all the fonts that are used as defaults in the ShinobiForms framework.
 */
@interface SFormFonts : NSObject

/** The default font used for the `label` on an `SFormFieldView` instance. */
+(UIFont *)labelFont;

/** The default font used for the `requiredLabel` text on an `SFormFieldView` instance. */
+(UIFont *)requiredLabelFont;

/** The default font used for the `errorLabel` text on an `SFormFieldView` instance. */
+(UIFont *)errorLabelFont;

/** The default font used for the `inputElement` text on an `SFormFieldView` instance. */
+(UIFont *)inputFont;

@end
