// SGridDelegate.h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SGridRowStruct.h"
#import "SGridArrowOrientation.h"
#import "SGridDragDirection.h"

typedef enum {
    SGridLineOrientationVertical,
    SGridLineOrientationHorizontal
} SGridLineOrientation;

@class ShinobiGrid;
@class SGridCell;
@class SGridAutoCell;
@class SGridLineStyle;
@class SGridColRowStyle;
@class SGridCoord;
@class SGridSectionHeaderStyle;
@class SGridCellStyle;
@class SGridTextInputCell;

/** The delegate of a ShinobiGrid object must adopt the SGridDelegate protocol. The delegate concerns itself with the style of rows, columns and gridlines and can receive notifications that a cell is about to be selected (via a single tap) or that a cell has been edited (via a double-tap).
 
 The delegate should only be used for styling where you wish to provide a style for a particular row, column or gridline, or where each row/column/gridline is to have its own distinct style. If you wish to apply a uniform row/column/gridline style for the entire grid then the properites `defaultRowStyle`, `defaultColumnStyle` and `defaultGridLineStyle` of your ShinobiGrid object are designed for this purpose and provide better performance than use of the delegate.
 
 @warning *Important* In certain cases row styles and column styles can conflict (a cell can belong to a row and column that have been given different styles). In this case the style is applied based on the `BOOL` `rowStylesTakePriority` property of the ShinobiGrid object.*/
@protocol SGridDelegate <UIScrollViewDelegate>

@optional
#pragma mark -
#pragma mark Columns and Row Styling
/** @name Styling Rows and Columns*/

/** Asks the delegate for the style to be used for a particular row within the ShinobiGrid object.
 
 Note that rows and sections are zero-indexed.
 
 @param grid The grid that is requesting the style.
 @param rowIndex The row within `grid` that is requesting the row style.
 @param sectionIndex The section that the row belongs to.
 
 @return The SGridColRowStyle object representing the style that will be applied to row at `rowIndex` of section at `sectionIndex` within `grid`.*/
- (SGridColRowStyle *)shinobiGrid:(ShinobiGrid *)grid styleForRowAtIndex:          (NSInteger) rowIndex inSection:(NSInteger)  sectionIndex __attribute__((warn_unused_result));

/** Asks the delegate for the style to be used for a particular column within the ShinobiGrid object.
 
 Note that columns are zero-indexed.
 
 @param grid The grid that is requesting the column style.
 @param colIndex The column within `grid` that is requesting the style.
 
 @return The SGridColRowStyle object representing the style that will be applied to column at `colIndex` within `grid`.*/
- (SGridColRowStyle *)shinobiGrid:(ShinobiGrid *)grid styleForColAtIndex:          (NSInteger) colIndex __attribute__((warn_unused_result));

/** Gives the delegate a chance to change the style that is about to be applied to a particular cell.
 
 This method is called whenever a cell is about to have a style applied to it, either upon a layout of the grid or upon a scroll gesture bringing a new cell into view.
 
 @param grid The grid that the cell belongs to.
 @param styleToApply The style about to be applied to the cell.
 @param coord The coord that identifies the location of the cell.
 */
- (void) shinobiGrid:(ShinobiGrid*) grid alterStyle:(SGridCellStyle*) styleToApply beforeApplyingToCellAtCoord:(const SGridCoord*) coord;


#pragma mark -
#pragma mark Gridline Styling
/** @name Styling Gridlines*/

/** Asks the delegate for the style to be used for a particular horizontal gridline within the ShinobiGrid object. 
 
 Gridlines are zero indexed - where the first horizontal grid line for a section appears underneath the first row of a section. Note that horizontal gridlines are zero-indexed within sections (that is to say that the first gridline in any section has a `gridLineIndex` of `0`). The last row of a section also has a gridline appear underneath it (unlike the last column of a grid). Returning `nil` for a particular gridline will result in the `defaultGridLineStyle` property of your ShinobiGrid object being applied.
 
 @param grid The grid that is requesting the horizontal gridline style.
 @param gridLineIndex The horizontal gridline for the section within `grid` that is requesting the style.
 @param sectionIndex The section that the horizontal gridline belongs to.
 
 @return The SGridLineStyle object representing the style that will be applied to the gridline at `gridLineIndex` with `orientation`.*/
- (SGridLineStyle *)  shinobiGrid:(ShinobiGrid *)grid     styleForHorizontalGridLineAtIndex: (NSInteger) gridLineIndex inSection:(NSInteger)  sectionIndex __attribute__((warn_unused_result));

/** Asks the delegate for the style to be used for a particular vertical gridline within the ShinobiGrid object. 
 
 Gridlines are zero indexed - where the first vertical grid line appears to the right of the first column of cells. Returning `nil` for a particular gridline will result in the `defaultGridLineStyle` property of your ShinobiGrid object being applied.
 
 @param grid The grid that is requesting the vertical gridline style.
 @param gridLineIndex The vertical gridline within `grid` that is requesting the style.
 
 @return The SGridLineStyle object representing the style that will be applied to the gridline at `gridLineIndex` with `orientation`.*/
- (SGridLineStyle *)  shinobiGrid:(ShinobiGrid *)grid     styleForVerticalGridLineAtIndex:   (NSInteger) gridLineIndex __attribute__((warn_unused_result));

#pragma mark -
#pragma mark Sections
/** @name Styling Section Headers */
 
/** Asks the delegate for the style to be used for a particular sections header. 
 
 Use this method if you wish to specify different styles for each section header. If you wish to style all section headers uniformly then use the `defaultSectionHeaderStyle` property of your ShinobiGrid object for better performance. Section headers are zero-indexed.
 
 @param grid The grid which owns the section that is requesting the header style.
 @param sectionIndex The index of the section that is requesting the header style.
 
 @return An object representing the style that will be applied to the section at `sectionIndex` of `grid`.*/
- (SGridSectionHeaderStyle *)shinobiGrid:(ShinobiGrid *)grid styleForSectionHeaderAtIndex:(NSInteger)  sectionIndex __attribute__((warn_unused_result));

#pragma mark -
#pragma mark Grid Layout/Render Notifications

/** @name Grid Layout/Render Notifications*/

/** Tells the delegate that the grid has finished laying out.
 
 The grid lays out, and subsequently calls this method, upon initial render/layout, section collapse/expand and device rotation.
 
 @param grid The grid which has finished laying out/rendering.*/
- (void) didFinishLayingOutShinobiGrid:(ShinobiGrid*) grid;

#pragma mark -
#pragma mark Section Notifications

/** @name Receiving Section Expand and Collapse Notifications*/

/** Asks the delegate whether a section within the ShinobiGrid should be allowed
 to expand. This will only be called when a user taps the header of a currently
 collapsed section. It will not be called when a section is expanded programmatically.
 
 @param grid The grid which contains the section which would like to expand
 @param sectionIndex The index of the section which would like to expand
 */
- (BOOL) shinobiGrid:(ShinobiGrid *)grid shouldExpandSectionAtIndex: (NSUInteger)sectionIndex;

/** Tells the delegate that a section within the ShinobiGrid object is about to be expanded.
 
 @param grid The grid which contains the section that is about to expand.
 @param sectionIndex The index of the section that is about to expand.
 */
- (void) shinobiGrid:(ShinobiGrid *)grid willExpandSectionAtIndex: (NSUInteger)sectionIndex;

/** Tells the delegate that a section within the ShinobiGrid object has expanded.
 
 @param grid The grid which contains the section that has expanded.
 @param sectionIndex The index of the section that has expanded.
 */
- (void) shinobiGrid:(ShinobiGrid *)grid didExpandSectionAtIndex: (NSUInteger)sectionIndex;

/** Asks the delegate whether a section within the ShinobiGrid should be allowed
 to collapse. This will only be called when a user taps the header of a currently
 expanded section. It will not be called when a section is collapsed programmatically.
 
 @param grid The grid which contains the section which would like to collapse
 @param sectionIndex The index of the section which would like to collapse
 */
- (BOOL) shinobiGrid:(ShinobiGrid *)grid shouldCollapseSectionAtIndex: (NSUInteger)sectionIndex;

/** Tells the delegate that a section within the ShinobiGrid object is about to be collapsed.
 
 @param grid The grid which contains the section that is about to collapse.
 @param sectionIndex The index of the section that is about to collapse.
 */
- (void) shinobiGrid:(ShinobiGrid *)grid willCollapseSectionAtIndex:(NSUInteger)sectionIndex;

/** Tells the delegate that a section within the ShinobiGrid object has collapsed.
 
 @param grid The grid which contains the section that has collapsed.
 @param sectionIndex The index of the section that has collapsed.
 */
- (void) shinobiGrid:(ShinobiGrid *)grid didCollapseSectionAtIndex:(NSUInteger)sectionIndex;

#pragma mark -
#pragma mark Cell Selection Notifications

/** @name Cell Selection Notifications*/

/** Asks the delegate whether a currently unselected cell that has been tapped should be marked as selected.
 
 This can be used to control selection on a cell by cell basis.
 
 @param grid The grid which contains the cell in question.
 @param gridCoord The coordinate of the cell in question.*/
- (BOOL) shinobiGrid:(ShinobiGrid*)grid shouldSelectCellAtCoord: (SGridCoord*) gridCoord __attribute__((warn_unused_result));

/** Tells the delegate that a cell within the ShinobiGrid object has been selected.
 
 @param grid The grid which contains the cell that has been selected.
 @param gridCoord The coordinate of the cell that has been selected.
 
 */
- (void) shinobiGrid:(ShinobiGrid *)grid willSelectCellAtCoord:(const SGridCoord *) gridCoord;

/** Tells the delegate that a cell within the ShinobiGrid object is about to be selected.
 
 This method gives the delegate an opportunity to apply a custom selection style/animation to the cell or another part of the grid.
 
 @param grid The grid which contains the cell that is about to be selected.
 @param gridCoord The coordinate of the cell that is about to be selected.
 
 */
- (void) shinobiGrid:(ShinobiGrid *)grid didSelectCellAtCoord: (const SGridCoord *) gridCoord;

/** Asks the delegate whether a currently selected cell that has been tapped should be marked as deselected.
 
 This can be used to control deselection on a cell by cell basis.
 
 @param grid The grid which contains the cell in question.
 @param gridCoord The coordinate of the cell in question.*/
- (BOOL) shinobiGrid:(ShinobiGrid *)grid shouldDeselectCellAtCoord:(const SGridCoord *)gridCoord __attribute__((warn_unused_result));

/** Tells the delegate that a cell within the ShinobiGrid object is about to be deselected.
 
 @param grid The grid containing the cell that will be deselected.
 @param gridCoord The coordinate of the cell that is about to be deselected.*/
- (void) shinobiGrid:(ShinobiGrid *)grid willDeselectCellAtCoord:(const SGridCoord *)gridCoord;

/** Tells the delegate that a cell within the ShinobiGrid object has been deselected.
 
 @param grid The grid containing the cell that has been deselected.
 @param gridCoord The coordinate of the cell that has been deselected.*/
- (void) shinobiGrid:(ShinobiGrid *)grid didDeselectCellAtCoord:(const SGridCoord *)gridCoord;


#pragma mark -
#pragma mark Cell Editing Notifications

/** @name Cell Editing Notifications*/

/** Asks the delegate if a cell should respond to an edit event.
 
 @param grid The grid containing the cell in question.
 @param cell The cell which wants to know if it should respond to an edit event.
 
 @return A BOOL that indicates if the cell will respond to an edit event. `YES` results in the cell responding, otherwise the cell ignores the edit event.*/
- (BOOL) shinobiGrid:(ShinobiGrid *)grid shouldBeginEditingAutoCell:(const SGridTextInputCell *) cell __attribute__((warn_unused_result));

/** Tells the delegate that a cell within the ShinobiGrid grid object will begin editing.
 
 @param grid The grid which contains the cell that will begin editing.
 @param cell The cell within `grid` that will begin editing.*/
- (void) shinobiGrid:(ShinobiGrid *)grid willBeginEditingAutoCell:(const SGridTextInputCell *) cell;

/** Tells the delegate that a cell within the ShinobiGrid grid object will begin editing.
 
 @warning *Important:* This method has been deprecated in preference of `shinobiGrid:willBeginEditingAutoCell:`.
 
 @param grid The grid which contains the cell that will begin editing.
 @param cell The cell within `grid` that will begin editing.*/
- (void) shinobiGrid:(ShinobiGrid *)grid willCommenceEditingAutoCell:(const SGridTextInputCell *) cell  __attribute__((deprecated ("Use shinobiGrid:willBeginEditingAutoCell: instead.")));

/** Informs the delegate that a cell within the ShinobiGrid object has been edited.
 
 This method gives the delegate an opportunity to feed back any changes that the user makes to the grid to the data source. Note that this delegate method only works in conjunction with SGridAutoCell (or its descendants).
 
 @param grid The grid which contains the cell that has been edited.
 @param cell The cell within `grid` that has been edited.*/
- (void) shinobiGrid:(ShinobiGrid *)grid didFinishEditingAutoCell:(const SGridTextInputCell *) cell;

#pragma mark -
#pragma mark Cell Gesture Notifications

/** @name Cell Gesture Notifications*/

/** Tells the delegate that a cell within the ShinobiGrid object has been tapped.
 
 @param grid The grid containing the cell that has been tapped.
 @param gridCoord The coordinate of the cell that has been tapped.
 @param isDoubleTap Indicates whether the cell has been double tapped (single tap otherwise). */
- (void) shinobiGrid:(ShinobiGrid *)grid didTapCellAtCoord:(const SGridCoord *) gridCoord isDoubleTap:(BOOL)isDoubleTap;

/** Asks the delegate whether a cell in the grid can respond to a double tap.
 Use this method to speed up single taps on cells which don't respond to a double tap.
 @param grid The grid containing the cell that has been tapped.
 @param cell The cell which may be double tapped.
 */
- (BOOL) shinobiGrid:(ShinobiGrid *)grid cellCanRespondToDoubleTap:(SGridCell *)cell __attribute__((warn_unused_result));

#pragma mark -
#pragma mark Row Selection Notifications
/** @name Receiving Row Selection Notifications*/
/** Asks the delegate whether the indicated row should be marked as selected as the result of a tap gesture on a cell.
 
 This method can only be called if the grid's cellSelectionMode is set to SGridSelectionModeRowSingle or SGridSelectionModeRowMulti. Note that the cell selection/deselection delegate methods will be called after this method.
 
 @param grid The ShinobiGrid which contains the row in question.
 @param row The row which may or may not be selected depending on the return value.
 
 @return A BOOL that indicates if row should be marked as selected.*/
- (BOOL) shinobiGrid:(ShinobiGrid *)grid shouldSelectRow:(SGridRow) row __attribute__((warn_unused_result));

/** Informs the delegate that the selection of an entire row is about to happen as a result of the user having tapped a cell. 
 
Note that cellSelectionMode must be set to SGridSelectionModeRowSingle or SGridSelectionModeRowMulti for this delegate method to be called and that the cell selection delegate methods such as shinobiGrid:didSelectCellAtCoord: will be called after this method.
 
 @param grid The grid that is about to have a row set as selected.
 @param row The row that is about to be selected.*/
- (void) shinobiGrid:(ShinobiGrid*) grid willSelectRow:(SGridRow) row;

/** Informs the delegate that the selection of an entire row has just happened as a result of the user having tapped a cell.
 
 Note that cellSelectionMode must be set to SGridSelectionModeRowSingle or SGridSelectionModeRowMulti for this delegate method to be called and that the cell selection delegate methods such as shinobiGrid:didSelectCellAtCoord: will be called before this method.
 
 @param grid The grid that that has just had a row set as selected.
 @param row The row that has just been set as selected.*/
- (void) shinobiGrid:(ShinobiGrid*) grid didSelectRow:(SGridRow) row;

/** Asks the delegate whether the currently selected row should be marked as deselected as the result of a tap gesture on a cell.
 
 This method can only be called if the grid's cellSelectionMode is set to SGridSelectionModeRowSingle or SGridSelectionModeRowMulti. Note that the cell selection/deselection delegate methods will be called after this method.
 
 @param grid The ShinobiGrid which contains the row in question.
 @param row The row which may or may not be deselected depending on the return value.
 
 @return A BOOL that indicates if row should be marked as deselected.*/
- (BOOL) shinobiGrid:(ShinobiGrid *)grid shouldDeselectRow:(SGridRow) row __attribute__((warn_unused_result));

/** Informs the delegate that the deselection of an entire row is about to happen as a result of the user having tapped a cell.
 
 Note that cellSelectionMode must be set to SGridSelectionModeRowSingle or SGridSelectionModeRowMulti for this delegate method to be called and that the cell selection delegate methods such as shinobiGrid:didSelectCellAtCoord: will be called after this method.
 
 @param grid The grid that is about to have a row set as deselected.
 @param row The row that is about to be deselected.*/
- (void) shinobiGrid:(ShinobiGrid*) grid willDeselectRow:(SGridRow) row;

/** Informs the delegate that the deselection of an entire row has just happened as a result of the user having tapped a cell.
 
 Note that cellSelectionMode must be set to SGridSelectionModeRowSingle or SGridSelectionModeRowMulti for this delegate method to be called and that the cell selection delegate methods such as shinobiGrid:didSelectCellAtCoord: will be called before this method.
 
 @param grid The grid that has just had a row set as deselected.
 @param row The row that has just been set as deselected.*/
- (void) shinobiGrid:(ShinobiGrid*) grid didDeselectRow:(SGridRow) row;

#pragma mark -
#pragma mark Column Resizing Notifications
/** @name Column Resizing Notifications*/

/** Asks the deleage whether a column should be allowed to resize in response to
 a user's pinch gesture.
 
 @param grid The grid that contains the column which wants to resize.
 @param columnIndex The index of the column that is about to begin resizing.
 */
- (BOOL) shinobiGrid:(ShinobiGrid *)grid shouldBeginResizingColumnAtIndex:(NSUInteger) columnIndex;


/** Tells the delegate that a column is about to begin resizing.
 
 This method will be called once before any resizing actually takes place.
 
 @param grid The grid that contains the column that is about to begin resizing.
 @param columnIndex The index of the column that is about to begin resizing.*/
- (void) shinobiGrid:(ShinobiGrid *)grid willBeginResizingColumnAtIndex:(NSUInteger) columnIndex;


/** Tells the delegate that a column will resize to a new width.
 
 This method is called continously as a user's pinch gesture changes. Each call to this method is made just prior to changing a columns width. If you want the width to be set to something other than `newWidth` then see the method `shinobiGrid:widthForResizingColAtIndex:`.
 
 @param grid The grid containing the column that will be resized.
 @param columnIndex The index of the column that will be resized.
 @param currentWidth The width that the column at `columnIndex` currently has.
 @param newWidth The width that the column at `columnIndex` will change to.
 @param xCenter The center, in points, of the column that is about to begin resizing.
 */

- (void)      shinobiGrid:(ShinobiGrid *)grid 
  willResizeColumnAtIndex:(NSUInteger)columnIndex 
                fromWidth:(CGFloat) currentWidth 
                  toWidth:(CGFloat) newWidth
              withXCenter:(CGFloat) xCenter;

/** Asks the grid for the width that a column that is currently being resized should be set to.
 
 @param grid The grid requesting the width for the resizing column.
 @param columnIndex The index of the column that is being resized.
 @param currentWidth The current width of the resizing column.
 @param targetWidth The width that the resizing column will be set to if this method had not been implemented (or `nil` is returned from this method).
 
 @return An NSNumber object that represents the width that the resizing column will be set to. Return nil if you wish for the target width to be set.*/
- (NSNumber*) shinobiGrid:(ShinobiGrid*) grid widthForResizingColAtIndex:(NSUInteger) columnIndex withCurrentWidth:(CGFloat) currentWidth targetWidth:(CGFloat) targetWidth __attribute__((warn_unused_result));


/** Tells the delegate that a column has resized to a new width.
 
 This method is called continously as a user's pinch gesture changes. Each call to this method is made just after a column's width has changed.
 
 @param grid The grid containing the column that has been resized.
 @param columnIndex The index of the column that has been resized.
 @param oldWidth The width that the column at `columnIndex` used to be before the resize.
 @param newWidth The width that the column at `columnIndex` now has.*/
- (void)   shinobiGrid:(ShinobiGrid *)grid 
didResizeColumnAtIndex:(NSUInteger) columnIndex 
             fromWidth:(CGFloat) oldWidth 
               toWidth:(CGFloat) newWidth;


/** Tells the delegate that a column is about to complete resizing. This method
 is called once per resizing operation - just after the column user's pinch gesture
 has ended.
 
 @param grid The grid containing the column which has been resized
 @param columnIndex The index of the column which has been resized
 @param oldWidth The width that the column at `columnIndex` was before the resize.
 @param newWidth The width that the column at `columnIndex` now has
 */
- (void)         shinobiGrid:(ShinobiGrid *)grid
willEndResizingColumnAtIndex:(NSUInteger) columnIndex
                   fromWidth:(CGFloat) oldWidth
                     toWidth:(CGFloat) newWidth;


/** Tells the delegate that a column has completed. This method
 is called once per resizing operation - just after the column user's pinch gesture
 has ended.
 
 @param grid The grid containing the column which has been resized
 @param columnIndex The index of the column which has been resized
 @param oldWidth The width that the column at `columnIndex` was before the resize.
 @param newWidth The width that the column at `columnIndex` now has 
 */
- (void)        shinobiGrid:(ShinobiGrid *)grid
didEndResizingColumnAtIndex:(NSUInteger) columnIndex
                  fromWidth:(CGFloat) oldWidth
                    toWidth:(CGFloat) newWidth;


#pragma mark -
#pragma mark Column and Row Reordering Notifications
/** @name Column and Row Reordering Notifications*/

/** Asks the delegate for which drag and drop directions are permitted. This query is triggered from a gesture originating on the cell at a given coord.
 
 @param grid The grid asking for the drag decision.
 @param coord The coord of the cell that the gesture originated from.
 
 @return An entry from the SGridDragDirection enum that controls the action the grid will take.*/
- (SGridDragDirection) shinobiGrid:(ShinobiGrid*)grid permittedDragDirectionForCellAtCoord:(SGridCoord*) coord;

/** Informs the delegate that two columns within the ShinobiGrid object have been switched.
 
 This method gives the delegate an opportunity to update the data source appropriately.
 
 @param grid The grid that contains the columns that have been switched.
 @param colIndexSwitched The first switched column.
 @param colIndexSwitchedWith The second switched column.
 
 @warning *Important* When a user drags and drops a column this only reorders the currently visible cells. Therefore it is important to update your data source so that when scrolling/panning takes place, the cells that become visible appear in the correct order.*/

- (void) shinobiGrid:(ShinobiGrid *)grid colAtIndex:(NSInteger)  colIndexSwitched hasBeenSwitchedWithColAtIndex:(NSInteger)  colIndexSwitchedWith;


/** Informs the delegate that the column reordering operation is about to be completed
 
 This method is called before the column is dropped back into position when the
 user's dragging gesture has been completed.
 
 @param grid The grid which contains the column which has been reordered
 @param colIndex The index of the column in its final resting place
 */
- (void) shinobiGrid:(ShinobiGrid *)grid willEndReorderingColumnAtIndex:(NSUInteger) colIndex;

/** Informs the delegate that the column reordering operation has been completed
 
 This method is called after the column is dropped back into position when the
 user's dragging gesture has been completed.
 
 @param grid The grid which contains the column which has been reordered
 @param colIndex The index of the column in its final resting place
 */
- (void) shinobiGrid:(ShinobiGrid *)grid didEndReorderingColumnAtIndex:(NSUInteger) colIndex;


/** Informs the delegate that two rows within the ShinobiGrid object have been switched.
 
 This method gives the delegate an opportunity to update the data source appropriately.
 
 @param grid The grid that contains the rows that have been switched.
 @param rowSwitched The first switched row.
 @param rowSwitchedWith The second switched row.
 
 @warning *Important* When a user drags and drops a row this only reorders the currently visible cells. Therefore it is important to update your data source so that when scrolling/panning takes place, the cells that become visible appear in the correct order.*/
- (void) shinobiGrid:(ShinobiGrid *)grid row: (SGridRow) rowSwitched hasBeenSwitchedWithRow: (SGridRow) rowSwitchedWith;

/** Informs the delegate that the row reordering operation is about to be completed
 
 This method is called before the row is dropped back into position when the
 user's dragging gesture has been completed.
 
 @param grid The grid which contains the row which has been reordered
 @param row The grid row in its final resting place
 */
- (void) shinobiGrid:(ShinobiGrid *)grid willEndReorderingRow:(SGridRow) row;

/** Informs the delegate that the row reordering operation has been completed
 
 This method is called after the row is dropped back into position when the
 user's dragging gesture has been completed.
 
 @param grid The grid which contains the row which has been reordered
 @param row The grid row in its final resting place
 */
- (void) shinobiGrid:(ShinobiGrid *)grid didEndReorderingRow:(SGridRow) row;



#pragma mark -
#pragma mark Reordering Arrow Notifications
/** @name Reordering Arrow Notifications*/
/** Asks the delegate for an image that will be used for an arrow that is displayed when the user initiates the drag/drop of a column/row.
 
 @param grid The grid that is requesting the arrow image.
 @param orientation The orientation of the image that is being requested - this signifies whether the arrow is pointing up, down, left or right.
 @param gridCoord The coordinates of the cell that will display the arrow image.
 
 @return A UIImage that will be used for the arrow in the cell at `gridCoord` that points in the direction `orientation`.*/
- (UIImage*) shinobiGrid:(ShinobiGrid*) grid arrowImageForOrientation:(SGridArrowOrientation) orientation forCellAtCoord:(const SGridCoord*)gridCoord;

/** Asks the delegate for the offset of an arrow image that is going to be displayed due to the user having initiated the drag/drop of a column/row. 
 
 This method allows you to provide an offset that will change the position of the arrow image that is about to be displayed.
 
 @param grid The gird that is requesting the offset.
 @param orientation The orientation of the arrow that will have the offset applied to it.
 @param gridCoord The coordintates of the cell that will display the arrow image.
 
 @return A CGPoint that represents the offset that will be applied to the arrow in the cell at `gridCoord` that points in the direction `orientation`.*/
- (CGPoint) shinobiGrid:(ShinobiGrid*) grid offsetForArrowImageWithOrientation:(SGridArrowOrientation) orientation forCellAtCoord:(const SGridCoord*)gridCoord;

@end
