//
//  SFormSectionView.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SFormSectionLayout;
@class SFormSectionView;

/** A form section.
 
 A section is used to split up a form fields into distinct groupings.
 */
@interface SFormSection : NSObject

/** Create a section containing the given fields.
 
 This is the designated initializer.
 */
-(instancetype)initWithFields:(NSArray *)fields;

/** The fields contained in the section.
 */
@property (nonatomic, copy) NSArray *fields;

/** The title of this section.
 */
@property (nonatomic, strong) NSString *title;

@end
