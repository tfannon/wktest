//
//  SFormSegmentedControl.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

/** A `UISegmentedControl` subclass with extended editing events.
 
 This subclass extends `UISegmentedControl` to provide a writable `inputView` and `inputAccessoryView` giving the control an input view and input accessory view.
 */
@interface SFormSegmentedControl : UISegmentedControl

/** The custom input view to display when the receiver becomes the first responder. */
@property (nonatomic, readwrite) UIView *inputView;

/** The custom input accessory view to display when the receiver becomes the first responder. */
@property (nonatomic, readwrite) UIView *inputAccessoryView;

/** Insert an image or a string at the specified segment index.
 
 There will be no effect if `segmentedContent` isn't an `NSString` or `UIImage`.
 
 @param segmentContent A `UIImage` or an `NSString` to insert.
 @param index The index to insert at.
 @param animated Whether the insertion is animated.
 */
-(void)insertSegment:(id)segmentContent atIndex:(NSUInteger)index animated:(BOOL)animted;

@end
