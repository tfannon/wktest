//
//  SFormViewBuilder.h
//  ShinobiForms
//
//  Created by Ryan Grey on 08/12/2014.
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFormViewBuilder.h"

@class SFormView;
@class ShinobiForm;

/** An object capable of building an `SFormView` from a `ShinobiForm` model object.
 */
@interface SFormFormViewBuilder : NSObject <SFormViewBuilder>

/** Build an `SFormView` from a `ShinobiForm` model object.
 
 @param model The `ShinobiForm` to build a view for.
 @return The `SFormView` created.
 */
- (SFormView *)buildViewFromModel:(ShinobiForm *)form;

@end
