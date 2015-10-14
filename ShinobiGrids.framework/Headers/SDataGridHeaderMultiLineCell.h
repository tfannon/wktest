//
//  SDataGridHeaderMultiLineCell.h
//  ShinobiControls_Source
//
//  Created by Jan Akerman on 02/07/2013.
//
//

#import "SDataGridMultiLineTextCell.h"

#import "SDataGridColumnSortOrder.h"
#import "SDataGridColumnSortMode.h"

/** This cell type is used in a ShinobiDataGrid in order to populate the header row. Each column has a header cell that can be retrieved with the `headerCell` method on an `SDataGridHeaderColumn` object.
 
 This cell type cannot respond to edit events or double tap events by default. It is possible to change this behaviour via subclassing - see the Methods for Subclassing.
 
 The implementation of `coordinate` in this class returns `nil`.*/

@interface SDataGridHeaderMultiLineCell : SDataGridMultiLineTextCell

- (void) applyStyle:(SDataGridCellStyle *)style;

#pragma mark -
#pragma mark Methods for Subclassing

/** @name Methods for Subclassing.*/
/** Dictates whether the cell responds to double taps.
 
 The default value for this is NO.*/
- (BOOL) respondsToDoubleTap;

/** The space to be used between the sort arrow and text.*/
@property (nonatomic, assign, readonly) CGFloat spaceBetweenArrowAndText;

/** Show and position the arrow for a given sort order.
 
 An implementation of this method would typically want to handle the adding/removing of the arrow, positioning of the arrow, as well as the use of different arrows for the specified sort orders.
 
     -(void)showArrowForSortOrder:(SDataGridColumnSortOrder)sortOrder sortMode:(SDataGridColumnSortMode)mode {
         // Remove old arrow.
         [_arrowView removeFromSuperview];
     
         // Load in custom arrow image.
         UIImage *arrow = [self customArrowForSortOrder:sortOrder];
         _arrowView = [[UIImageView alloc] initWithImage:arrow];
 
         // Position and add arrow.
         [self addSubview:_arrowView];
         _arrowView.frame = CGRectMake(0, 0, 50, 50);
     }
 
 @param sortOrder The sort order for which to display the arrow.
 @param sortMode The sort mode the column is currently in.
 */
- (void) showArrowForSortOrder:(SDataGridColumnSortOrder)sortOrder sortMode:(SDataGridColumnSortMode)sortMode;

@end
