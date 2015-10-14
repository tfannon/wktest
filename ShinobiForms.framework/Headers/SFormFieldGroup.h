//
//  SFormFieldValidationGroup.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

/** This class defines a grouping of fields. 
 
 Normally when a field's state is updated it notifies its observers (i.e. its associated view). When a field belongs to a group and its state changes, it updates its own observers and the observers of all other fields in the group. 
 
 This allows the observers of all field objects in the group to update themselves. This is handy if you want to ensure a field view updates how it looks when another field's value changes. An example of this might be two fields that validate by comparing against each other in a min-max type relationship. Adding the min field and the max field to a group allows you to ensure that both views will update how they look when either field is validated.
 */
@interface SFormFieldGroup : NSObject

/** The fields contained in the group
 
 The elements of this array must be subclasses of `SFormField` (i.e. `SFormTextField`).
 */
@property (nonatomic, copy) NSArray *fields;

@end
