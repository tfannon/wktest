//
//  SFormInputElementResponder.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

/** This protocol defines the interface for any object wishing to respond to input element events.
 
 The responder methods on this protocol are typically added as target selectors to a field's input element. The responder is resposible for setting these target selectors up via the `addResponderMethodsToInputElement:` method.
 */
@protocol SFormInputElementResponder <NSObject>

/** @name Responding to Input Element Events */

/** Notifies the responder that an input element has begun editing.
 
 @param inputElement The input element that did begin editing.
 */
-(void)didBeginEditingInputElement:(id)inputElement;

/** Notifies the responder that an input element's value changed.
 
 @param inputElement The input element that has has its value changed.
 */
-(void)didChangeValueForInputElement:(id)inputElement;

/** Notifies the responder that an input element has finished editing.
 
 @param inputElement The input element that has finished editing.
 */
-(void)didEndEditingInputElement:(id)inputElement;

/** @name Setup and Teardown of Responder Methods */

/** Adds the appropriate responder methods as target selectors to `inputElement`.
 
 A typical implementation of this might add `didBeginEditingInputElement:`, `didChangeValueForInputElement:` and `didEndEditingInputElement:` as target selectors to `inputElement` for UIControlEvents appropriate to the `inputElement` type.
 
 @param inputElement The input element to add the responder methods to.
 */
-(void)addResponderMethodsToInputElement:(UIView *)inputElement;

/**
 Removes the appropriate target selectors from `inputElement`.
 
 A typical implementation of this would remove any target selectors added by the `addResponderMethodsToInputElement:` counterpart.
 
 @param inputElement The input element to remove the responder methods from.
 */
-(void)removeResponderMethodsFromInputElement:(UIView*)inputElement;

@end
