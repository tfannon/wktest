//
//  ShinobiForm.h
//  ShinobiForms
//
//  Copyright (c) 2013 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFormField, SFormView;
@protocol SFormLayout, SFormFieldLayout, SFormNavigationToolbar, SFormDelegate;

/** A `ShinobiForm` is used to present input fields to a user in order to collect data.
 
 A `ShinobiForm` contains 1 or more `SFormSection`s that each owns a set of fields. An `SFormField` is used to collect users input and can give visual feedback as to the validity of any input.
 */
@interface ShinobiForm : NSObject

/** Create a form containing the given sections.
 
 This is the designated initializer.
 
 @param sections The sections to initialize the form with.
 */
-(instancetype)initWithSections:(NSArray *)sections;

#pragma mark - Sections

/** @name Sections */

/** The sections belonging to the form.
 
 This is an array of `SFormSection` objects. Assigning to this will cause any observing `SFormView` objects
 to create new views to represent each model object in the array.
 */
@property (nonatomic, copy) NSArray *sections;

#pragma mark - Extracting Values from the Form
/** @name Extracting Values from the Form */

/** Notify the delegate a submission has taken place. */
- (void)submit;

/** The form's delegate. */
@property (nonatomic, weak) id<SFormDelegate> delegate;

#pragma mark - Field Groups
/** @name Field Groups */

/** The field groups on a form.
 
 These objects should be of type `SFormFieldGroup`.
 */
@property (nonatomic, strong) NSArray *fieldGroups;

@end
