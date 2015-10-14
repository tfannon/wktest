//
//  SDataGridPullToActionState.h
//  ShinobiGrids
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//
//

#import <Foundation/Foundation.h>


/** The possible states of the Pull to Action control.
 
 * SDataGridPullToActionStateIdle: The Pull to Action control is not being animated, or interacted with.
 * SDataGridPullToActionStatePulling: The Pull to Action control is being pulled down, but has not yet triggered an action.
 * SDataGridPullToActionStateTriggered: The Pull to Action control has been pulled down past the `pullThreshold`, and an action has been triggered.
 * SDataGridPullToActionStateExecuting: The pull gesture on the control has finished, and the action is now executing.
 * SDataGridPullToActionStateRetracting: The action has now completed, and is now returning to the idle state.
 */
typedef NS_ENUM(NSUInteger, SDataGridPullToActionState)
{
    SDataGridPullToActionStateIdle,
    SDataGridPullToActionStatePulling,
    SDataGridPullToActionStateTriggered,
    SDataGridPullToActionStateExecuting,
    SDataGridPullToActionStateRetracting
};
