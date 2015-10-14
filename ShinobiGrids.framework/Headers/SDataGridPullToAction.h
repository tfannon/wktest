//
//  SGridPullToAction.h
//  ShinobiGrids
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "SDataGridPullToActionState.h"

@protocol SDataGridPullToActionDelegate;
@class SDataGridPullToActionStyle;

/** The `SGridPullToAction` control attaches to a scrollview, or any class which is a sub-class of `UIScrollView`. When the user pulls down the scroll view, the Pull to Action control is displayed. If the user pulls down the scroll view past a certain threshold, an action is triggered by the Pull to Action control.
 
 The Pull to Action control has a delegate, which is an instance of `SGridPullToActionDelegate`. The delegate is used to tell the control when the action is completed.
 */
@interface SDataGridPullToAction : NSObject

#pragma mark - Setup
/** @name Setup */

/** Initializes and returns an instance of the Pull to Action control with the given frame. */
-(instancetype)initWithFrame:(CGRect)frame;

/** The `UIScrollView` that the Pull to Action is attached to.
 
 We only hold a weak reference, as we are retained by the scrollView as one of its subviews. */
@property (nonatomic, assign) UIScrollView *scrollView;

/** Adds the Pull to Action control as a subview of the specified scrollview. */
- (void)addToScrollView:(UIScrollView*)scrollView;

/** Whether the Pull to Action control is currently visible. This defaults to `NO`. */
@property (nonatomic, assign) BOOL hidden;

/** The current frame of the Pull to Action control. */
@property (nonatomic, assign) CGRect frame;

#pragma mark - Pull to Action State
/** @name Pull to Action State */

/** The current distance that the Pull to Action has been pulled down by, in points. */
@property (nonatomic, readonly) CGFloat pulledAmount;

/** The distance at which an action is triggered, once the `pulledAmount` has exceeded this value.
 
 Defaults to `100` points.
 */
@property (nonatomic, assign) CGFloat pullThreshold;

/** The height of the Pull to Action control during its executing state.
 
 Defaults to `50` points. When the pull gesture ends after having passed the `pullThreshold`, the Pull to Action control will return to this height, until the `actionCompleted` method is called.
 */
@property (nonatomic, assign) CGFloat executingHeight;

#pragma mark - Delegation
/** @name Delegation */

/** The `delegate` for the Pull to Action control.
 
 Will be sent notifications about changes in state, and the triggering of actions. */
@property (nonatomic, assign) id<SDataGridPullToActionDelegate> delegate;

/** The delegate should call this once it has completed its action. This tells the Pull to Action control to retract back to its idle state. */
- (void)actionCompleted;

#pragma mark - Styling
/** @name Styling */

/** This property allows you to configure the look and feel of the Pull to Action control status view.
 */
@property (nonatomic, retain, readonly) SDataGridPullToActionStyle *style;

/** The status view associates each state of the Pull to Action control with some text.
 
 This text is displayed in the status label when the Pull to Action control is in that state.
 The default mappings are:
 
 SDataGridPullToActionStatePulling => @"Pull to update"
 SDataGridPullToActionStateTriggered => @"Release to update"
 SDataGridPullToActionStateExecuting => @"Loading..."
 
 No text is displayed by default for the remaining states.
 */
@property (nonatomic, retain) NSDictionary *textForStates;

@end
