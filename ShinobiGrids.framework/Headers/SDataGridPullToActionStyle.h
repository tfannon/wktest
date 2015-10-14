//
//  SGridPullToActionStyle.h
//  ShinobiGrids
//
//  Created by Daniel Gorst on 08/05/2014.
//
//

#import <UIKit/UIKit.h>

@interface SDataGridPullToActionStyle : NSObject

#pragma mark - Pull to Action
/** @name Pull to Action */

/** The color of the Pull to Action view. */
@property (nonatomic, retain) UIColor *backgroundColor;

#pragma mark - Status View
/** @name Status View */

/** The color of the status view. */
@property (nonatomic, retain) UIColor *statusViewBackgroundColor;

/** The font of the status view's status label. */
@property (nonatomic, retain) UIFont *statusViewFont;

/** The color of the status view's status label text. */
@property (nonatomic, retain) UIColor *statusViewTextColor;

/** The fill color of the status view's arrow.
 */
@property (nonatomic, retain) UIColor *arrowColor;

/** The border color of the status view's arrow.
 */
@property (nonatomic, retain) UIColor *arrowBorderColor;

/** The border width of the status view's arrow.  This defaults to `0`.
 */
@property (nonatomic, retain) NSNumber *arrowBorderWidth;

@end
