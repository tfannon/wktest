//
//  SFormDelegate.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShinobiForm;

/** Protocol for any classes which act as a delegate of a `ShinobiForm`. Delegates are notified when data is submitted from the form, or if a submission was attempted but failed.
 */
@protocol SFormDelegate <NSObject>

@optional

/** The delegate is notified when the form is about to submit data.
 
 @param form The form containing the data.
 */
- (void)formWillSubmit:(ShinobiForm *)form;

/** The delegate is notified when data is submitted from the form. 
 
 @param form The form containing the data.
 */
- (void)formDidSubmit:(ShinobiForm *)form;

/** The delegate is notified when an attempt was made to submit data, but it failed.
 
 @param form The form containing the data.
 @param invalidFields The invalid fields in the form.
 */
- (void)form:(ShinobiForm *)form didNotSubmitWithInvalidFields:(NSArray *)invalidFields;

@end
