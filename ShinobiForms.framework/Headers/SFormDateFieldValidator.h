//
//  SFormDateFieldValidator.h
//  ShinobiForms
//
//  Created by Jan Akerman on 24/12/2014.
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormInvalidMessageProvider.h"

@class SFormDateField;

/** This protocol provides an interface to be implemented by any object wanting to validate date fields.*/
@protocol SFormDateFieldValidator <SFormInvalidMessageProvider>

/** Returns a `BOOL` value that indicates whether the date field is valid.
 
 @param field The date field to be validated. */
-(BOOL)validateDateField:(SFormDateField *)field;

@end
