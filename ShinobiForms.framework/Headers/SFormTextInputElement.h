//
//  SFormTextInputElement.h
//  ShinobiForms
//
//  Copyright (c) 2015 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

/** A `UITextField` subclass with additional functionaity.
 
 This `UITextField` provides an easy way to change the editing rect, enable/disable the iOS copy and paste menu, and enable/disable the cursor.
 */
@interface SFormTextInputElement : UITextField

/** The padding around the text field's editing area. */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/* Whether to show the copy and paste menu. */
@property (nonatomic, assign) BOOL showCopyAndPasteMenu;

/* Whether to show the cursor. */
@property (nonatomic, assign) BOOL showCursor;

@end
