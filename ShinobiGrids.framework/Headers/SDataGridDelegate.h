//
//  SDataGridDelegate.h
//  Dev
//
//  Created by Ryan Grey on 04/10/2012.
//
//

#import <Foundation/Foundation.h>
#import "SDataGridArrowOrientation.h"
#import "SDataGridColumnSortOrder.h"
#import "SDataGridDragDirection.h"

@class SDataGridRow;
@class ShinobiDataGrid;
@class SDataGridColumn;
@class SDataGridCoord;
@class SDataGridLineStyle;
@class SDataGridSectionHeaderStyle;
@class SDataGridCell;
@class SDataGridTextCell;
@class SDataGridCoord;
@class SDataGridCellStyle;
@class SDataGridLineStyle;


/** The delegate of a ShinobiDataGrid (data-grid) object must adopt the SDataGridDelegate protocol. The delegate concerns itself with the styling of the data-grid and can also receive notifications about actions the data-grid may take or has taken in response to events and interactions.
 
 The delegate should only be used for styling where you wish to provide a style for a particular row, column or gridline, or where each row/column/gridline is to have its own distinct style. If you wish to apply a uniform row/column/gridline style for the entire data-grid then the properites `defaultCellStyleForRows`, `defaultCellStyleForAlternateRows`, etc of your ShinobiDataGrid object are designed for this purpose and provide better performance than use of the delegate.
 
 **Hint:** _There are many layers to the grid and, as such, there are many layers of style objects. The application of these styles is subject to a strict precedence heirarchy, covered in more detail in the DataGridUserGuide_
 
*/

@protocol SDataGridDelegate <UIScrollViewDelegate>

@optional
#pragma mark -
#pragma mark Columns and Row Styling
/** @name Styling Rows and Columns*/

/** Asks the delegate for the height of a particular grid row.
 
 If you want every row in your grid to have the same height then using -[ShinobiDataGrid defaultRowHeight] is more efficient than using this method.
 
 @param grid The grid requesting the row height.
 @param rowIndex The index of the row within its section.
 @param sectionIndex The index of the section that the row belongs to.
 
 @return An NSNumber that reprsents the desired height of the row. Returning `nil` results in -[ShinobiDataGrid defaultRowHeight] being used.*/
- (NSNumber*) shinobiDataGrid:(ShinobiDataGrid*) grid heightForRowAtIndex:(NSInteger) rowIndex inSection:(NSInteger) sectionIndex;

/** Gives the delegate a chance to change the style that is about to be applied to a particular cell.
 
 This method is called whenever a cell is about to have a style applied to it, either upon a layout of the grid or upon a scroll gesture bringing a new cell into view.
 
 @param grid The grid that the cell belongs to.
 @param styleToApply The style about to be applied to the cell.
 @param coordinate The coordinate that identifies the location of the cell.
 */
- (void) shinobiDataGrid:(ShinobiDataGrid*) grid alterStyle:(SDataGridCellStyle*) styleToApply beforeApplyingToCellAtCoordinate:(SDataGridCoord*) coordinate;

#pragma mark -
#pragma mark Gridline Styling
/** @name Styling Gridlines*/

/** Asks the delegate for the style to be used for a particular horizontal gridline within the ShinobiDataGrid object.
 
 Gridlines are zero indexed - where the first horizontal grid line for a section appears underneath the first row of a section. Note that horizontal gridlines are zero-indexed within sections (that is to say that the first gridline in any section has a `gridLineIndex` of `0`). The last row of a section also has a gridline appear underneath it (unlike the last column of a grid). Returning `nil` for a particular gridline will result in the `defaultGridLineStyle` property of your ShinobiDataGrid object being applied.
 
 @param grid The grid that is requesting the horizontal gridline style.
 @param gridLineIndex The horizontal gridline for the section within `grid` that is requesting the style.
 @param sectionIndex The section that the horizontal gridline belongs to.
 
 @return The SDataGridLineStyle object representing the style that will be applied to the gridline at `gridLineIndex` with `orientation`.*/
- (SDataGridLineStyle *)  shinobiDataGrid:(ShinobiDataGrid *)grid     styleForHorizontalGridLineAtIndex: (NSInteger)gridLineIndex inSection:(NSInteger) sectionIndex;

/** Asks the delegate for the style to be used for a particular vertical gridline within the ShinobiDataGrid object.
 
 Gridlines are zero indexed - where the first vertical grid line appears to the right of the first column of cells. Returning `nil` for a particular gridline will result in the `defaultGridLineStyle` property of your ShinobiDataGrid object being applied.
 
 @param grid The grid that is requesting the vertical gridline style.
 @param gridLineIndex The vertical gridline within `grid` that is requesting the style.
 
 @return The SDataGridLineStyle object representing the style that will be applied to the gridline at `gridLineIndex` with `orientation`.*/
- (SDataGridLineStyle *)  shinobiDataGrid:(ShinobiDataGrid *)grid     styleForVerticalGridLineAtIndex:   (NSInteger)gridLineIndex;

#pragma mark -
#pragma mark Sections
/** @name Styling Section Headers*/
 
/** Asks the delegate for the style to be used for a particular sections header.
 
 Use this method if you wish to specify different styles for each section header. If you wish to style all section headers uniformly then use the `defaultSectionHeaderStyle` property of your ShinobiDataGrid object for better performance. Section headers are zero-indexed.
 
 @param grid The grid which owns the section that is requesting the header style.
 @param sectionIndex The index of the section that is requesting the header style.
 
 @return An object representing the style that will be applied to the section at `sectionIndex` of `grid`.*/
- (SDataGridSectionHeaderStyle *)shinobiDataGrid:(ShinobiDataGrid *)grid styleForSectionHeaderAtIndex:(NSInteger) sectionIndex;

#pragma mark -
#pragma mark Grid Layout/Render Notifications

/** @name Grid Layout/Render Notifications*/

/** Tells the delegate that the grid has finished laying out.
 
 The grid lays out, and subsequently calls this method, upon initial render/layout, section collapse/expand and device rotation.
 
 @param grid The grid which has finished laying out/rendering.*/
- (void) didFinishLayingOutShinobiDataGrid:(ShinobiDataGrid*) grid;

#pragma mark -
#pragma mark Section Notifications

/** @name Receiving Section Expand and Collapse Notifications*/

/** Asks the delegate whether a section within the ShinobiDataGrid should be allowed
 to expand. This will only be called when a user taps the header of a currently
 collapsed section. It will not be called when a section is expanded programmatically.
 
 @param grid The grid which contains the section which would like to expand
 @param sectionIndex The index of the section which would like to expand
 */
- (BOOL) shinobiDataGrid:(ShinobiDataGrid *)grid shouldExpandSectionAtIndex:(NSUInteger)sectionIndex;

/** Tells the delegate that a section within the ShinobiDataGrid object is about to be expanded.
 
 @param grid The grid which contains the section that is about to expand.
 @param sectionIndex The index of the section that is about to expand.
 */
- (void) shinobiDataGrid:(ShinobiDataGrid *)grid willExpandSectionAtIndex: (NSUInteger)sectionIndex;

/** Tells the delegate that a section within the ShinobiDataGrid object has expanded.
 
 @param grid The grid which contains the section that has expanded.
 @param sectionIndex The index of the section that has expanded.
 */
- (void) shinobiDataGrid:(ShinobiDataGrid *)grid didExpandSectionAtIndex: (NSUInteger)sectionIndex;

/** Asks the delegate whether a section within the ShinobiDataGrid should be allowed
 to collapse. This will only be called when a user taps the header of a currently
 expanded section. It will not be called when a section is collapsed programmatically.
 
 @param grid The grid which contains the section which would like to collapse
 @param sectionIndex The index of the section which would like to collapse
 */
- (BOOL) shinobiDataGrid:(ShinobiDataGrid *)grid shouldCollapseSectionAtIndex:(NSUInteger)sectionIndex;

/** Tells the delegate that a section within the ShinobiDataGrid object is about to be collapsed.
 
 @param grid The grid which contains the section that is about to collapse.
 @param sectionIndex The index of the section that is about to collapse.
 */
- (void) shinobiDataGrid:(ShinobiDataGrid *)grid willCollapseSectionAtIndex:(NSUInteger)sectionIndex;

/** Tells the delegate that a section within the ShinobiDataGrid object has collapsed.
 
 @param grid The grid which contains the section that has collapsed.
 @param sectionIndex The index of the section that has collapsed.
 */
- (void) shinobiDataGrid:(ShinobiDataGrid *)grid didCollapseSectionAtIndex:(NSUInteger)sectionIndex;

#pragma mark -
#pragma mark Cell Selection Notifications

/** @name Cell Selection Notifications*/

/** Asks the delegate whether a currently unselected cell that has been tapped should be marked as selected.
 
 This can be used to control selection on a cell by cell basis.
 
 @param grid The grid which contains the cell in question.
 @param gridCoordinate The coordinate of the cell in question.*/
- (BOOL) shinobiDataGrid:(ShinobiDataGrid*) grid shouldSelectCellAtCoordinate: (const SDataGridCoord *) gridCoordinate __attribute__((warn_unused_result));

/** Tells the delegate that a cell within the ShinobiDataGrid object has been selected.
 
 @param grid The grid which contains the cell that has been selected.
 @param gridCoordinate The coordinate of the cell that has been selected.
 
 */
- (void) shinobiDataGrid:(ShinobiDataGrid *)grid willSelectCellAtCoordinate:(const SDataGridCoord *) gridCoordinate;

/** Tells the delegate that a cell within the ShinobiDataGrid object is about to be selected.
 
 This method gives the delegate an opportunity to apply a custom selection style/animation to the cell or another part of the grid.
 
 @param grid The grid which contains the cell that is about to be selected.
 @param gridCoordinate The coordinate of the cell that is about to be selected.
 
 */
- (void) shinobiDataGrid:(ShinobiDataGrid *)grid didSelectCellAtCoordinate: (const SDataGridCoord *) gridCoordinate;

/** Asks the delegate whether a currently selected cell that has been tapped should be marked as deselected.
 
 This can be used to control deselection on a cell by cell basis.
 
 @param grid The grid which contains the cell in question.
 @param gridCoordinate The coordinate of the cell in question.*/
- (BOOL) shinobiDataGrid:(ShinobiDataGrid *)grid shouldDeselectCellAtCoordinate:(const SDataGridCoord *)gridCoordinate __attribute__((warn_unused_result));

/** Tells the delegate that a cell within the ShinobiDataGrid object is about to be deselected.
 
 @param grid The grid containing the cell that will be deselected.
 @param gridCoordinate The coordinate of the cell that is about to be deselected.*/
- (void) shinobiDataGrid:(ShinobiDataGrid *)grid willDeselectCellAtCoordinate:(const SDataGridCoord *)gridCoordinate;

/** Tells the delegate that a cell within the ShinobiDataGrid object has been deselected.
 
 @param grid The grid containing the cell that has been deselected.
 @param gridCoordinate The coordinate of the cell that has been deselected.*/
- (void) shinobiDataGrid:(ShinobiDataGrid *)grid didDeselectCellAtCoordinate:(const SDataGridCoord *)gridCoordinate;

#pragma mark -
#pragma mark Cell Editing Notifications

/** @name Cell Editing Notifications*/

/** Asks the delegate if a cell should respond to an edit event.
 
 Note that if you implement this method it overrides the `editable` property on the grid's columns.
 
 @param grid The grid containing the cell in question.
 @param coordinate The coordinate of the cell which wants to know if it should respond to an edit event.
 
 @return A BOOL that indicates if the cell will respond to an edit event. `YES` results in the cell responding, otherwise the cell ignores the edit event.*/
- (BOOL) shinobiDataGrid:(ShinobiDataGrid *)grid shouldBeginEditingCellAtCoordinate:(const SDataGridCoord*) coordinate __attribute__((warn_unused_result));

/** Tells the delegate that a cell within the ShinobiDataGrid grid object will begin editing.
 
 @param grid The grid which contains the cell that will begin editing.
 @param coordinate The coordinate of the cell within `grid` that will begin editing.*/
- (void) shinobiDataGrid:(ShinobiDataGrid *)grid willBeginEditingCellAtCoordinate:(const SDataGridCoord*) coordinate;

/** Informs the delegate that a cell within the ShinobiDataGrid object has been edited.
 
 This method gives the delegate an opportunity to feed back any changes that the user makes to the grid to the data source.
 
 @param grid The grid which contains the cell that has been edited.
 @param coordinate The coordinate of the cell within `grid` that has been edited.*/
- (void) shinobiDataGrid:(ShinobiDataGrid *)grid didFinishEditingCellAtCoordinate:(const SDataGridCoord*) coordinate;

#pragma mark -
#pragma mark Cell Gesture Notifications

/** @name Cell Gesture Notifications*/

/** Tells the delegate that a cell within the ShinobiDataGrid object has been tapped.
 
 @param grid The grid containing the cell that has been tapped.
 @param gridCoordinate The coordinate of the cell that has been tapped.
 @param isDoubleTap Indicates whether the cell has been double tapped (single tap otherwise). */
- (void) shinobiDataGrid:(ShinobiDataGrid *)grid didTapCellAtCoordinate:(const SDataGridCoord *) gridCoordinate isDoubleTap:(BOOL)isDoubleTap;

/** Asks the delegate whether a cell in the grid can respond to a double tap.
 Use this method to speed up single taps on cells which don't respond to a double tap.
 @param grid The grid containing the cell that has been tapped.
 @param cell The cell which may be double tapped.
 */
- (BOOL) shinobiDataGrid:(ShinobiDataGrid *)grid cellCanRespondToDoubleTap:(const SDataGridCell *)cell __attribute__((warn_unused_result));

#pragma mark -
#pragma mark Row Selection Notifications
/** @name Receiving Row Selection Notifications*/
/** Asks the delegate whether the indicated row should be marked as selected as the result of a tap gesture on a cell. 
 
 This method can only be called if the grid's cellSelectionMode is set to SDataGridSelectionModeRowSingle or SDataGridSelectionModeRowMulti. Note that the cell selection/deselection delegate methods will be called after this method.
 
 @param grid The grid which contains the row in question.
 @param row The row which may or may not be selected depending on the return value.
 
 @return A BOOL that indicates if row should be marked as selected.*/
- (BOOL) shinobiDataGrid:(ShinobiDataGrid *)grid shouldSelectRow:(SDataGridRow*) row __attribute__((warn_unused_result));

/** Informs the delegate that the selection of an entire row is about to happen as a result of the user having tapped a cell.
 
  Note that cellSelectionMode must be set to SDataGridSelectionModeRowSingle or SDataGridSelectionModeRowMulti for this delegate method to be called and that the cell selection delegate methods such as shinobiDataGrid:didSelectCellAtCoordinate: will be called before this method.
 
 @param grid The grid that is about to have a row set as selected.
 @param row The row that is about to be selected.*/
- (void) shinobiDataGrid:(ShinobiDataGrid*) grid willSelectRow:(SDataGridRow*) row;

/** Informs the delegate that the selection of an entire row has just happened as a result of the user having tapped a cell.
 
 Note that cellSelectionMode must be set to SDataGridSelectionModeRowSingle or SDataGridSelectionModeRowMulti for this delegate method to be called and that the cell selection delegate methods such as shinobiDataGrid:didSelectCellAtCoordinate: will be called before this method.
 
 @param grid The grid that is about to have a row set as selected.
 @param row The row that is about to be selected.*/
- (void) shinobiDataGrid:(ShinobiDataGrid*) grid didSelectRow:(SDataGridRow*) row;

/** Asks the delegate whether the currently selected row should be marked as deselected as the result of a tap gesture on a cell.
 
 This method can only be called if the grid's cellSelectionMode is set to SDataGridSelectionModeRowSingle or SDataGridSelectionModeRowMulti. Note that the cell selection/deselection delegate methods will be called after this method.
 
 @param grid The ShinobiGrid which contains the row in question.
 @param row The row which may or may not be deselected depending on the return value.
 
 @return A BOOL that indicates if row should be marked as deselected.*/
- (BOOL) shinobiDataGrid:(ShinobiDataGrid *)grid shouldDeselectRow:(SDataGridRow*) row __attribute__((warn_unused_result));

/** Informs the delegate that the deselection of an entire row is about to happen as a result of the user having tapped a cell.
 
 Note that cellSelectionMode must be set to SDataGridSelectionModeRowSingle or SDataGridSelectionModeRowMulti for this delegate method to be called and that the cell selection delegate methods such as shinobiGrid:didSelectCellAtCoordinate: will be called after this method.
 
 @param grid The grid that is about to have a row set as deselected.
 @param row The row that is about to be deselected.*/
- (void) shinobiDataGrid:(ShinobiDataGrid*) grid willDeselectRow:(SDataGridRow*) row;

/** Informs the delegate that the deselection of an entire row has just happened as a result of the user having tapped a cell.
 
 Note that cellSelectionMode must be set to SDataGridSelectionModeRowSingle or SDataGridSelectionModeRowMulti for this delegate method to be called and that the cell selection delegate methods such as shinobiGrid:didSelectCellAtCoordinate: will be called before this method.
 
 @param grid The grid that has just had a row set as deselected.
 @param row The row that has just been set as deselected.*/
- (void) shinobiDataGrid:(ShinobiDataGrid*) grid didDeselectRow:(SDataGridRow*) row;

#pragma mark -
#pragma mark Column Resizing Notifications
/** @name Column Resizing Notifications*/

/** Tells the delegate that a column has resized to a new width.
 
 This method is called continously as a user's pinch gesture changes. Each call
 to this method is made just prior to changing a columns width. If you want the
 width to be set to something other than `newWidth` then see the method
 `shinobiDataGrid:widthForResizingColAtIndex:`.
 
 @param grid The grid containing the column that will be resized.
 @param column The column that will be resized.
 @param currentWidth The width that the column at `columnIndex` currently has.
 @param newWidth The width that the column at `columnIndex` will change to.
 */

- (void)  shinobiDataGrid:(ShinobiDataGrid *)grid
          didResizeColumn:(SDataGridColumn *)column
                fromWidth:(CGFloat) currentWidth
                  toWidth:(CGFloat) newWidth;

/** Asks the grid for the width that a column that is currently being resized should be set to.
 
 @param grid The grid requesting the width for the resizing column.
 @param column The column that is being resized.
 @param currentWidth The current width of the resizing column.
 @param targetWidth The width that the resizing column will be set to if this method had not been implemented (or `nil` is returned from this method).
 
 @return An NSNumber object that represents the width that the resizing column will be set to. Return nil if you wish for the target width to be set.*/
- (NSNumber*) shinobiDataGrid:(ShinobiDataGrid*) grid
       widthForResizingColumn:(SDataGridColumn *)column
             withCurrentWidth:(CGFloat) currentWidth
                  targetWidth:(CGFloat) targetWidth;


/** Tells the delegate that a column is about to end resizing a column
 
 This method is called once the user's pinch gesture has been completed.
 
 @param grid The grid containing the column that has been resized.
 @param column The column that has been resized.
 @param oldWidth The width that the column used to be before the resize.
 @param newWidth The width that the column now has.*/
- (void)shinobiDataGrid:(ShinobiDataGrid *)grid
  willEndResizingColumn:(SDataGridColumn *) column
              fromWidth:(CGFloat) oldWidth
                toWidth:(CGFloat) newWidth;


/** Tells the delegate that a column has completed resizing a column
 
 This method is called once the user's pinch gesture has been completed.
 
 @param grid The grid containing the column that has been resized.
 @param column The index of the column that has been resized.
 @param oldWidth The width that the column used to be before the resize.
 @param newWidth The width that the column now has.*/
- (void)shinobiDataGrid:(ShinobiDataGrid *)grid
   didEndResizingColumn:(SDataGridColumn *) column
              fromWidth:(CGFloat) oldWidth
                toWidth:(CGFloat) newWidth;


#pragma mark -
#pragma mark Column and Row Reordering Notifications
/** @name Column and Row Reordering Notifications*/

/** Asks the delegate for which drag and drop directions are permitted. This query is triggered from a gesture originating on the cell at a given coord.
 
 @warning *Important* Note that row dragging cannot be initiated from a frozen row and that column dragging cannot be initiated from a frozen column despite what you return from this method.
 
 @param grid The grid asking for the drag decision.
 @param coordinate The coordinate of the cell that the gesture originated from.
 
 @return An entry from the SDataGridDragDirection enum that controls the action the grid will take.*/
- (SDataGridDragDirection) shinobiDataGrid:(ShinobiDataGrid*)grid permittedDragDirectionForCellAtCoordinate:(SDataGridCoord*) coordinate;

/** Informs the delegate that two columns within the ShinobiDataGrid object have been switched.
 
 This method gives the delegate an opportunity to update the data source appropriately.
 
 @param grid The grid that contains the columns that have been switched.
 @param columnSwitched The first switched column.
 @param columnSwitchedWith The second switched column.
 
 @warning *Important* When a user drags and drops a column this only reorders the currently visible cells. Therefore it is important to update your data source so that when scrolling/panning takes place, the cells that become visible appear in the correct order.*/

- (void) shinobiDataGrid:(ShinobiDataGrid *)grid didReorderColumn:(SDataGridColumn *)columnSwitched withColumn:(SDataGridColumn *)columnSwitchedWith;

/** Informs the delegate that the specified column is about to complete reordering
 
 This is called when the user's drag gesture has been completed.
 
 @param grid The datagrid which contains the column
 @param column The column which is about to be dropped
 */
- (void)shinobiDataGrid:(ShinobiDataGrid *)grid willEndReorderingColumn:(SDataGridColumn *)column;

/** Informs the delegate that the specified column has completed reordering
 
 This is called when the user's drag gesture has been completed.
 
 @param grid The datagrid which contains the column
 @param column The column which has been dropped
 */
- (void)shinobiDataGrid:(ShinobiDataGrid *)grid didEndReorderingColumn:(SDataGridColumn *)column;

/** Informs the delegate that two rows within the ShinobiDataGrid object have been switched.
 
 This method gives the delegate an opportunity to update the data source appropriately.
 
 @param grid The grid that contains the columns that have been switched.
 @param rowSwitched The first switched row.
 @param rowSwitchedWith The second switched row.
 
 @warning *Important* When a user drags and drops a row this only reorders the currently visible cells. Therefore it is important to update your data source so that when scrolling/panning takes place, the cells that become visible appear in the correct order.*/
- (void) shinobiDataGrid:(ShinobiDataGrid *)grid didReorderRow:(SDataGridRow*)rowSwitched withRow:(SDataGridRow*)rowSwitchedWith;


/** Informs the delegate that the specified row is about to complete reordering
 
 This is called when the user's drag gesture has been completed.
 
 @param grid The datagrid which contains the row
 @param row The row which is about to be dropped
 */
- (void)shinobiDataGrid:(ShinobiDataGrid *)grid willEndReorderingRow:(SDataGridRow *)row;

/** Informs the delegate that the specified row has completed reordering
 
 This is called when the user's drag gesture has been completed.
 
 @param grid The datagrid which contains the row
 @param row The row which has been dropped
 */
- (void)shinobiDataGrid:(ShinobiDataGrid *)grid didEndReorderingRow:(SDataGridRow *)row;

#pragma mark -
#pragma mark Column Sorting Notifications
/** @name Column Sorting Notifications*/
/** Informs the delegate that a column is about to change its sortOrder as a result of a user's tap gesture on said column's header cell.
 
 @param grid The grid that the column in question belongs to.
 @param column The column that is about to have its sortOrder changed.
 @param newSortOrder The sort order that column is about to have its sortOrder changed to.*/
- (void) shinobiDataGrid:(ShinobiDataGrid *)grid willChangeSortOrderForColumn:(SDataGridColumn*) column to:(SDataGridColumnSortOrder) newSortOrder;

/** Informs the delegate that a column has just had its sortOrder changed as a result of a user's tap gesture on said column's header cell.
 
 @param grid The grid that the column in question belongs to.
 @param column The column that has just had its sortOrder changed
 @param oldSortOrder The sort order that the column had prior to the change.
 */
- (void) shinobiDataGrid:(ShinobiDataGrid *)grid didChangeSortOrderForColumn:(SDataGridColumn*) column from:(SDataGridColumnSortOrder) oldSortOrder;

@end
