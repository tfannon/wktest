//
//  SFormFieldViewIterator.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFormFieldViewIterator.h"

/** Provides the next field with an `inputElement` capable of becoming the first responder.
 */
@interface SFormResponderFieldViewIterator : NSObject <SFormFieldViewIterator>

@end
