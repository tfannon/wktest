//
//  SFormSectionLayout.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ShinobiForm, SFormSectionView;

/** An object capable of laying out the contents of an `SFormSectionView`.
 
 Possible implementations include:
 
 - `SFormSectionLayoutAlignedVertically`: Positions fields vertically, aligned by their left edges.
 - `SFormSectionLayoutAlignedVerticallyByInput`: Positions fields vertically, aligned by the left edge of their input elements.
 */
@protocol SFormSectionLayout <NSObject>

/** Lays out the contents of a section view.

 A typical implementation of this would layout the section view's title and iterate through the fields,
 modifying the frame of each one so they are appropriately positioned within the section view.
 
 @param sectionView The section view to be laid out.
 */
- (void)layoutSectionView:(SFormSectionView *)sectionView;

/** The ideal size for a section in this layout.
 
 This method should calculate and return the ideal size for the field view.
 
 @param sectionView The section view.
 */
- (CGSize)idealSizeForSectionView:(SFormSectionView *)sectionView;

@end
