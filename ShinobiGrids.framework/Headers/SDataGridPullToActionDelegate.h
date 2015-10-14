//
//  SGridPullToActionDelegate.h
//  ShinobiGrids
//
//  Created by Daniel Gorst on 07/05/2014.
//
//

#import <Foundation/Foundation.h>

@class SDataGridPullToAction;

@protocol SDataGridPullToActionDelegate <NSObject>

@required

/** An action has been triggered on the Pull to Action control.
 
 This will be called when a gesture pulls the control down past its `pullThreshold`, and then the gesture finishes.
 
 When the triggered action has completed, you will need to call `[pullToAction actionCompleted]` to signal that the
 Pull to Action control should return to an idle position.
 */
-(void)pullToActionTriggeredAction:(SDataGridPullToAction*)pullToAction;

@end
