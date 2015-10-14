//
//  SFormKeyboardManager.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Modifies a given scroll view in response to keyboard & field selection events.
 
 This manager provides an easy way to improve a user's experience whilst interacting with a form embedded within
 a scroll view. A manager initialised with a scroll view will:
 
 1. Increase the scroll view's bottom `contentInset` adding extra space if the keyboard would overlap with the form within
 the scroll view. This requires that the form is a subview of the scroll view.
 
 2. Modify the `contentInset` of the given scroll view to scroll any focused fields into view.
 */
@interface SFormScrollViewManager : NSObject

/** Initialise this instance with a scroll view to manage.
 
 @param scrollView The scroll view to manage.
 */
-(instancetype)initWithScrollView:(UIScrollView *)scrollView;

/** The scroll view being managed. */
@property (nonatomic, weak, readonly) UIScrollView *scrollView;

@end
