// SGridSelectableElement.h
#import <Foundation/Foundation.h>

@protocol SGridEventResponder <NSObject>

@required

#pragma mark -
#pragma mark Methods for Subclassing
/** @name Methods for Subclassing.

 It is unlikely that that you should ever need to call these methods directly - they have been included for potential subclassing purposes.*/

/** This message will be passed to this object when it is required to respond to a selection event.*/
- (void) respondToSelectionEvent;

/** This message will be passed to this object when it is required to respond to an edit event.*/
- (void) respondToEditEvent;

@end
