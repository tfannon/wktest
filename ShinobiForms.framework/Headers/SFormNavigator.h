//
//  SFormNavigator.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

/** The `SFormNavigator` protocol defines the methods needed to provide navigation for an `SFormNavigationToolbar`. 
 */
@protocol SFormNavigator <NSObject>

/** Focus on the field view previous to the currently selected field view.
 */
-(void)focusPreviousFieldView;

/** Focus on the field view next to the currently selected field view.
 */
-(void)focusNextFieldView;

/** Dismiss the current field view. 
 */
-(void)dismissFieldView;

@end
