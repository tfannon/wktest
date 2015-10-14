//
//  SFormViewBuilder.h
//  ShinobiForms
//
//  Created by Jan Akerman on 09/12/2014.
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** An object capable of building a `UIView` from a model object.
 */
@protocol SFormViewBuilder <NSObject>

/** Creates a `UIView` representation from a given model object.
 
 @param model The model object to create a view for.
 @return The view created.
 */
- (UIView *)buildViewFromModel:(id)model;

@end
