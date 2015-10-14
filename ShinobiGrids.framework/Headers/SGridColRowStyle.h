// SGridColRowStyle.h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SGridCellStyle.h"

/** An object of type SGridColRowStyle represents a style to be applied to an entire row or column.
 The methods `shinobiGrid:styleForRowAtIndex:inSection:` and `shinobiGrid:styleForColAtIndex:` of the object that implements the SGridDelegate protocol are
 intended to return objects of this type in order to apply a style to an entire row or column.
 
 See SGridCellStyle for details regarding style precedence and conflicts.
*/

@interface SGridColRowStyle : SGridCellStyle {
    BOOL    horizontalFreeze;
    BOOL    verticalFreeze;
}

#pragma mark -
#pragma mark Initialzation
/** @name Initializing a SGridColRowStyle Object*/

/** Creates and returns an object that represents the style of an entire row or column with the specified parameters.*/
- (id) initWithSize:(NSNumber *)newSize withBackgroundColor:(UIColor*) backgroundColor
      withTextColor:(UIColor*)textColor
  withTextAlignment:(NSTextAlignment)textAlignment
withVerticalTextAlignment:(UIControlContentVerticalAlignment)textVerticalAlignment
           withFont:(UIFont*)font;

/** Creates an autoreleased object using the corresponding initWithSize:withBackgroundColor:withTextColor:withFont:.*/
+ (id) styleWithSize:(NSNumber *)newSize withBackgroundColor:(UIColor*) backgroundColor
       withTextColor:(UIColor*)textColor
   withTextAlignment:(NSTextAlignment)textAlignment
withVerticalTextAlignment:(UIControlContentVerticalAlignment)textVerticalAlignment
            withFont:(UIFont*)font;

/** Creates and returns an object that represents the style of an entire row or column with the specified parameters.*/
- (id) initWithSize:(NSNumber *)newSize withBackgroundColor:(UIColor*) backgroundColor
      withTextColor:(UIColor*)textColor
           withFont:(UIFont*)font;

/** Creates an autoreleased object using the corresponding initWithSize:withBackgroundColor:withTextColor:withFont:.*/
+ (id) styleWithSize:(NSNumber *)newSize withBackgroundColor:(UIColor*) backgroundColor
       withTextColor:(UIColor*)textColor
            withFont:(UIFont*)font;

/** Uses a cell style to create an object of this class.*/
+ (id) styleWithSize:(NSNumber*) newSize withCellStyle:(SGridCellStyle*) cellStyle;

#pragma mark -
#pragma mark Col/Row Dimensions
/** @name Col/Row Dimensions*/

/** This property either represents the width of a column or the height of a row.
 
 Default value is nil. Having this set at nil results in auto-sizing of a cell's appropriate dimension. If auto-sizing is not desired then set this to be non-nil.
 A size of zero will mean that the column or row is not displayed.*/
@property (nonatomic, retain) NSNumber *size;

/** If the grid is unable to find a size to use (col width or row height) then the grid will calculate some to use. The grid will try to fit all content into an unscrollable grid, but will not reduce a given size below minimumSize. Minimum size is also adhered to when the user is pinching to resize a column.
 
 Default value is `nil`.*/

@property (nonatomic, retain) NSNumber *minimumSize;

@end
