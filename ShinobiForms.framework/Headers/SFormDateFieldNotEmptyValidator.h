//
//  SFormDateFieldNotEmptyValidator.h
//  ShinobiForms
//
//  Created by Jan Akerman on 24/12/2014.
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormDateFieldValidator.h"

/** This validator checks to see if the date field is empty.
 
 This works by checking to see if the field's value is nil. If this is the case
 then the field is invalid. If otherwise, the field is valid. */
@interface SFormDateFieldNotEmptyValidator : NSObject <SFormDateFieldValidator>

/** A string representing the invalid message to provide. */
@property (nonatomic, strong) NSString *invalidMessage;

@end
