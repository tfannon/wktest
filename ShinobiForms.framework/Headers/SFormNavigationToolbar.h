//
//  SFormNavigationToolbar.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFormFieldView;
@protocol SFormNavigator;

/** The protocol `SFormNavigationToolbar` defines the methods needed for a navigation compatable toolbar.
 
 The built in `ShinobiForm` navigation allows users to move between fields easily without having to physically tap on
 a field. A `UIView` implementing these methods as advised will be compatable with the out of the box navigation.
 */
@protocol SFormNavigationToolbar <NSObject>

/** Returns the toolbar view.

 This method should return the `UIView` toolbar. Simply return `self` if your toolbar is the object implementing this protocol.
 */
-(UIView *)toolbarView;

/** Called when a field view is selected.
 
 Here the toolbar is given information about the newly focused field view. The toolbar is also given information as
 to whether there are any field views previous or next to the newly selected field view, allowing the toolbar to enable/disable
 navigation buttons.
 */
-(void)fieldView:(SFormFieldView *)fieldView becameFirstResponderHasPrevious:(BOOL)hasPrevious hasNext:(BOOL)hasNext;

/** Set object responsible for navigating between fields of the form.
 
 You can tell the toolbar's field navigator to focus on the previous or next field by calling `focusPreviousField` or
 `focusNextField` respectively.
 
 If you want your toolbar to be compatible with the built in navigation then you need to store the `fieldNavigator` provided and call it when you wish to navigate between feilds.
  */
-(void)setFieldNavigator:(id<SFormNavigator>)fieldNavigator;

@end
