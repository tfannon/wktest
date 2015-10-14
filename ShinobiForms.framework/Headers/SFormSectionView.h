//
//  SFormSectionView.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFormSection;

@protocol SFormSectionLayout;

/** A view for displaying a grouping of fields.
 */
@interface SFormSectionView : UIView

/** The model being presented.
 */
@property (nonatomic, strong) SFormSection *model;

#pragma mark - Appearance
/** @Appearance */

/** The title label of this section.
 
 This `text` value of this label is kept in sync with the `model`'s `title` property.
 */
@property (nonatomic, strong) UILabel *titleLabel;

/** The field views displayed by this section view.

 Replacing this array will add any `SFormFieldView` objects as subviews to the section.
 
 @warning Updating the `model`'s fields array will cause this array to be replaced with auto-generated field views for the model.
 */
@property (nonatomic, copy) NSArray *fieldViews;

#pragma mark - Layout
/** @name Layout */

/** Used to layout this form's content.
 
 The layout manager is used in the `layoutSubviews` method to layout the content of the section. Setting this to nil is
 an easy way to stop the section from doing any layout if you want the frames of any added fields to be respected.
 
 Default is a `SFormSectionLayoutAlignedVertically`.
 */
@property (nonatomic, strong) id<SFormSectionLayout> layout;

@end
