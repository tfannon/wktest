//
//  SFormSectionBaseLayout.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFormSectionLayout.h"

/** An abstract base class, providing default values for `SFormSectionLayoutStrategy` properties.
 
 By default, `verticalSpacing` is `10` points, and the `inset` is `(20,20)`.
 */
@interface SFormSectionBaseLayout : NSObject<SFormSectionLayout>

/** The amount of padding around the field views.
 
 These `edgeInsets` will be taken into account when calculating the `idealSizeForSectionView:` and calculating a field view's origin during layout. The section layout will not change field view sizes to respect these `edgeInsets`.
 */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/** The amount of vertical padding to be applied between the title and the first field in the section. */
@property (nonatomic, assign) CGFloat titleFieldPadding;

/** The amount of vertical padding to be applied between subviews in a view. */
@property (nonatomic, assign) CGFloat verticalSpacing;

@end
