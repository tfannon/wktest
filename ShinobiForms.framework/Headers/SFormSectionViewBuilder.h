//
//  SFormSectionViewBuilder.h
//  ShinobiForms
//
//  Created by Jan Akerman on 09/12/2014.
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFormViewBuilder.h"

@class SFormSectionView;
@class SFormSection;

/** An object capable of building an `SFormSectionView` from an `SFormSection` model object.
 */
@interface SFormSectionViewBuilder : NSObject <SFormViewBuilder>

/** Build an `SFormSectionView` from an `SFormSection` model object.
 
 @param model The `SFormSection` to build a view for.
 @return The `SFormSectionView` created.
 */
-(SFormSectionView *)buildViewFromModel:(SFormSection *)model;

@end
