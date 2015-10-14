//
//  SFormFieldValidator.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFormInvalidMessageProvider <NSObject>

/** A string representing the invalid message to provide. 
 
 Typically used by a field's view if the input is invalid. 
 */
-(NSString *)invalidMessage;

@end
