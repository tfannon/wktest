//
//  SFormToolbar.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SFormNavigationToolbar.h"

@protocol SFormNavigator;

/** A toolbar with "previous" and "next" buttons to allow easy navigation around the form.
 
 The `UIBarButtonItem`s on the toolbar contain `UIButton`s with direction arrow images.
 */
@interface SFormToolbar : UIToolbar <SFormNavigationToolbar>

/** The button to focus on the previous field on a form.
 
 By default, pressing this will call the toolbar's `fieldNavigator` to focus the previous field.
 */
@property (nonatomic, strong, readonly) UIBarButtonItem *previousButton;

/** The button to focus on the next field on a form.
 
 By default, pressing this will call the toolbar's `fieldNavigator` to focus the next field.
 */
@property (nonatomic, strong, readonly) UIBarButtonItem *nextButton;

/** A button to dismiss the currently selected field.
 
 By default, pressing this will call the toolbar's `fieldNavigator` to dismiss the field.
 */
@property (nonatomic, strong, readonly) UIBarButtonItem *doneButton;

@end
