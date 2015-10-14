//
//  SDataGridStyle.h
//  Dev
//
//  Created by Ryan Grey on 19/02/2013.
//
//

#import "SDataGridWrapper.h"
#import <UIKit/UIKit.h>

@class SDataGridGradient;


/**
An object of this type is used, in certain circumatances, to provide a style
that will be used for an SDataGridCell. If this object contains a style that
cannot be applied to the cell in question then the style will be ignored - for
example, we have a textColor and try to apply it to an SDataGridCell that has
no text, then the textColor is ignored.

Note that where there are style conflicts, the application of style occurs
according to the level of precidence.  For example, if a cell is returned as
having a blue background by applying this in the SDataGridDataSource protocol
method `shinobiDataGrid:prepareCellForDisplay:` but we later specify that the
row that the cell belongs to should have a red background (by implementing the
SDataGridDelegate protocol), the cell will take on the most specific style. In
this case we specify a row style and a cell style - therefore the most specific
style is the cell style and so the cell in question will have a blue
background. All other cells in the row will have a red background (unless a
more specific style is applied elsewhere).

Most specific to least specific, the styling order is: Giving a cell a
background color itself (this cannot be done with size).  A style returned from
a delegate method is checked next. If nil, or a specific member of the style is
nil, the following is checked: The `defaultColumnStyle` and `defaultRowStyle`
properties on the grid object owning the cell.

If no appropriate style is found, autosizing takes place and default styles are
used.
 */

@interface SDataGridCellStyle : SDataGridWrapper





/**@name Initializing*/

/** Returns a style object that represents the passed parameters. Passing nil to any parameter results in a default value being used.*/
- (id) initWithBackgroundColor:(UIColor*) backgroundColor withTextColor:(UIColor*)textColor withTextAlignment:(NSTextAlignment)textAlignment withVerticalTextAlignment:(UIControlContentVerticalAlignment)textVerticalAlignment withFont:(UIFont*)font;

/** Returns an autoreleased style object using the corresponding `initWith...` method.*/
+ (id) styleWithBackgroundColor:(UIColor*) backgroundColor withTextColor:(UIColor*)textColor withTextAlignment:(NSTextAlignment)textAlignment withVerticalTextAlignment:(UIControlContentVerticalAlignment)textVerticalAlignment withFont:(UIFont*)font;

/** Returns a style object that represents the passed parameters. Passing nil to any parameter results in a default value being used.*/
- (id) initWithBackgroundColor:(UIColor*) backgroundColor withTextColor:(UIColor*)textColor withFont:(UIFont*)font;

/** Returns an autoreleased style object using the corresponding `initWith...` method.*/
+ (id) styleWithBackgroundColor:(UIColor*) backgroundColor withTextColor:(UIColor*)textColor withFont:(UIFont*)font;



/** @name Style Properties*/

/** The color that will be used for the background of the cell.*/
@property (nonatomic, retain) UIColor *backgroundColor;
/** The color that will be used for the text of the cell.
 
 If the cell has no text then this property is ignored.*/
@property (nonatomic, retain) UIColor *textColor;
/** The horizontal alignment that will be used for the text of the cell.
 
 If the cell has no text then this property is ignored.*/
@property (nonatomic, assign) NSTextAlignment textAlignment;
/** The font that will be used for the text of the cell.
 
 If the cell has no text then this property is ignored.*/
@property (nonatomic, retain) UIFont *font;

/** The vertical alignment that will be applied to any text within the cell.
 
 If the cell has no text then this property is ignored.*/
@property (nonatomic, assign) UIControlContentVerticalAlignment textVerticalAlignment;

/** The gradient that will be applied to the cell
 */
@property (nonatomic, retain) SDataGridGradient *gradient;

/** The indents that pad the inside of the cell
 */
@property (nonatomic) UIEdgeInsets contentInset;


@end
