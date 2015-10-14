// SGrid.h

#import "SGridDataSource.h"
#import "SGridDelegate.h"

#import <UIKit/UIKit.h>
#import "SGridRowStruct.h"
#import "SGridSelectionMode.h"
#import "SGridLinesOnTop.h"
#import "SGridEventMask.h"
#import "SGridDragDirection.h"

@class SGridCell;
@class SGridCellStyle;
@class SGridDataSource;
@class SGridDelegate;
@class SGridLineStyle;
@class SGridBorderStyle;
@class SGridColRowStyle;
@class SGridLayer;
@class SGridCoord;
@class SGridScrollIndicatorLayer;
@class SGridCoordMutable;
@class SGridSectionHeaderStyle;
@class SGridDataSourceDelegateManager;
@class SGridArrow;
@class SGridMultiTouchRecognizer;
@class SGridDoubleTapGestureRecognizer;
@class SGridColourBlender;
@class SGridBlockQueue;
@protocol SGridDelegate;

typedef enum {
    SGridPanDecisionNone,
    SGridPanDecisionHorizontal,
    SGridPanDecisionVertical
} SGridPanDecision;

typedef enum {
    SGridAutoScrollNon,
    SGridAutoScrollUp,
    SGridAutoScrollLeft = SGridAutoScrollUp,
    SGridAutoScrollDown,
    SGridAutoScrollRight = SGridAutoScrollDown,
}SGridAutoScroll;

/** The ShinobiGrid class is intended for easy construction of a grid structure that is presented in columns, rows and sections, composed of cells, separated by gridlines, that display content to the user. Columns, rows and sections are zero-indexed, where the first column in a grid is at index 0, the first row in a section is at index 0 and the first section in the grid is at index 0. Cells can be located within a grid from their grid coordinate.
 
 Sections group rows horizontally and have section headers that allow the user to tap and collapse a section. The grid will have one section by default, but this can be altered by implementing the appropriate SGridDelegate method.
 
 A ShinobiGrid object can present content that is too large for its own frame by allowing for panning and scrolling. This behaviour is automatic where the content dimensions (total cell heights or widths) are greater than the grid's dimensions - no additional setup/calibration is required. The grid will calculate the height of columns and width of rows if none are supplied - in order to stop this behaviour simply implement the appropriate style method from SGridDelegate or apply the appropriate default style on the grid itself (such as defaultRowStyle etc.).
 
 A ShinobiGrid object must have an associated object that acts as the data source (which must conform to the SGridDataSource protocol). The data source provides the necessary information to construct the grid, such as number of rows, sections and columns, and the content to be displayed within each cell. The data source concerns itself solely with the data model, and issues relating to the style of the grid are controlled through the delegate. 
 @warning *Important* The datasource property is a *weak* reference to the grid's datasource. This means you must maintain a reference to it, to prevent prevent the datasource from being autoreleased / released by ARC.
 
 The delegate of the ShinobiGrid object must conform to the SGridDelegate protocol and can be used to provide styles for specific rows/columns/gridlines. Only provide a delegate for your ShinobiGrid object if you wish to provide a style for a specific element of the grid. If you wish to style the grid in a uniform manner (every gridline will be styled identically etc) then the properties such as defaultRowStyle, defaultColumnStyles and defaultGridLineStyle are designed for this purpose. As such it is not necessary for a ShinobiGrid to have a delegate. 
 @warning *Important* The delegate property is a *weak* reference to the grid's delegate. This means you must maintain a reference to it, to prevent prevent the delegate from being autoreleased / released by ARC.
 
 ShinobiGrid uses cell pooling to make your grid as memory efficient as possible. Cells that are not currently visible are returned to an internal cell pool for later use and cells that become visible due to users scrolling/panning are retrieved from this pool. This means that ShinobiGrid caches cells only for visible rows and columns, but caches styling objects for the entire grid. For ShinobiGrid to be able to pool cells correctly it needs to know what the cells will be used for - this is where the dequeueReusableCellWithIdentifier: method is utilised. You should use a different `reuseIdentifier` for each distinct type of cell within your grid - for example if you have header cells and normal cells in your grid, you might use the identifiers `"HEADER"` and `"NORMAL"`. For code examples of using the identifiers see the ShinobiGrid sample apps.
 
 @warning *Important* The allocation/instantiation of cells must be done via the dequeueReusableCellWithIdentifier: method.*/

@interface ShinobiGrid : UIScrollView <UIScrollViewDelegate> {
    
    SGridLineStyle               *defaultGridLineStyle;   
    SGridBorderStyle             *defaultBorderStyle;
    SGridColRowStyle             *defaultRowStyle;
    SGridColRowStyle             *defaultColumnStyle;
    BOOL                         rowStylesTakePriority;
    
    
@private
    NSMutableDictionary *activeArrows;
    
    BOOL            needsDrawArrows;

    SGridDataSourceDelegateManager *dataSourceDelegateManager;
    
    UIView                       *masterContent;
    
    SGridLayer                   *liquidLayer; //this layer acts as the master layer
    //these layers mimic the master layer according to whichever directions they are not frozen in
    SGridLayer                   *verticallyFrozenLayer;
    SGridLayer                   *horizontallyFrozenLayer;
    SGridLayer                   *staticLayer;
    SGridScrollIndicatorLayer    *verticalScrollIndicatorLayer;
    SGridScrollIndicatorLayer    *horizontalScrollIndicatorLayer;
    
    NSNumber                     *initialDefaultColWidth;
    NSNumber                     *initialDefaultRowHeight;
    BOOL                         userSetDefaultColStyle;
    BOOL                         userSetDefaultRowStyle;
    BOOL                         keyBoardIsShowing;
    
    NSMutableArray               *_selectedGridCoords;
    
    SGridDoubleTapGestureRecognizer    *doubleTapToEdit;
    UITapGestureRecognizer       *singleTapToSelect;
    UILongPressGestureRecognizer *holdToReorder;
    SGridMultiTouchRecognizer    *resizeGesture;
    CGFloat                         cellReorderOffset; // don't snap the centre to the user's finger
    
    NSInteger                           colResizingIndex;
    BOOL                          colResizing;
    UIImageView                  *colResizingFloater;
    
    SGridCoordMutable            *draggingIndex;
    BOOL                          currentlyDragging;
    NSInteger                           sectionWaitingForExpand; // when we hover over a section header, remember the section we are expanding
    
    CGPoint                      positionToSnapDraggingCellsTo;
    CGPoint                      lastTouchPosition;
    BOOL                         reordering; //Needed for when deciding whether to deselect a cell
    BOOL                         userDragging; //YES when user is dragging a row/col - needed to decide when to set below flag. If the user is dragging a row and we enter the scrollViewDidScroll method, then we know that the below flag should be set to YES.
    SGridAutoScroll              autoScroll;
    
    SGridDragDirection        _dragDecision;
    CGPoint                      lastContentOffset;
    
    SGridPanDecision              _panDecision;
    CGPoint                       _initialPanOffset;
    
    NSMutableArray               *visibleRowIndexes;
    NSMutableArray               *visibleColIndexes;
    
    BOOL                          poolDequeCalled;
    
    void                         *_reserved;
    BOOL                          initialLoad;
    BOOL                          frozenColumnsStillNeedsValidation;
    BOOL                          frozenRowsStillNeedsValidation;
    NSUInteger                    innerNumberOfFrozenColumns;
    NSUInteger                    innerNumberOfFrozenRows;
    BOOL                          scrollCallbackInProgress;
    BOOL                          reloadingGrid;
    BOOL                          deferredLayout;
    
    NSUInteger                    numberOfSectionsCollapsed;
    BOOL                          aSectionIsCollapsing;
    
    UIImage                      *defaultArrowImage;
    
    BOOL                         _blendsDelegateRowStylesWithDefaultRowStyle;
    BOOL                         _ignoresDelegateColStylesForFirstRow;
    SGridColourBlender           *_backgroundColorBlender;
    SGridColourBlender           *_textColorBlender;
    
    SGridCoord                   *_userPrimaryCellCoord;

    struct { BOOL x, y; }         _contentOffsetStrictlyPositive;
    
    SGridBlockQueue              *_delayUntilReloadQueue;
    
}

#pragma mark -
#pragma mark Changing a ShinobiGrid's Default Styles
/** @name Changing a ShinobiGrid's Default Styles*/

/** This property is the default style that will be applied to all gridlines that belong this this ShinobiGrid object. 
 
 Any style applied to a gridline via the delegate object will take priority over this property.*/
@property (nonatomic, retain) SGridLineStyle       *defaultGridLineStyle;

/** This property represents the style that will be applied to this grid's content border. 
 
 The border belongs the the content of the grid and not the grid itself. If you wish to apply a border to the grid then this can be accomplished as with a regular UIView through the use of the `layer` property (as ShinobiGrid is a descendant of UIView).*/
@property (nonatomic, retain) SGridBorderStyle     *defaultBorderStyle;

/** This property represents the style that will be applied to all section headers in this grid. 
 
 To specify individual styles for each (or a particular) section header then see the `shinobiGrid:headerStyleForSectionAtIndex:` method of SGridDelegate. Note that a style specified with the delegate method will take priority over this property.*/
@property (nonatomic, retain) SGridSectionHeaderStyle *defaultSectionHeaderStyle;

/** This property sets a default row style that will be used in all rows in all sections in this grid. Use this property to quickly set a base row style for the grid. 
 
 This property will be overriden by any style that is more specific, such as styles assigned in the delegate methods or styles assigned when returning a cell in the datasource method.*/
@property (nonatomic, retain) SGridColRowStyle     *defaultRowStyle;

/** The default style to be used upon row/cell selection.*/
@property (nonatomic, retain) SGridCellStyle *defaultSelectedCellStyle;

/** This property sets a default column style that will be used in all columns in this grid. Use this property to quickly set a base column style for the grid. 
 
 This property will be overriden by any style that is more specific, such as styles assigned in the delegate methods or styles assigned when returning a cell in the datasource method.*/
@property (nonatomic, retain) SGridColRowStyle     *defaultColumnStyle;

/** If the grid cannot find a row height to use then it will try to calculate one to use. It does this by trying to fit every row into the height of the grid - this property dictates the minimum row height that will be used in this case.
 
 @warning *Important:* This method has been deprecated in preference of `defaultRowStyle.minimumSize`.*/
@property (nonatomic, retain) NSNumber *minimumRowHeight __attribute__((deprecated("Use defaultRowStyle.minimumSize instead.")));

/** If the grid cannot find a column width to use then it will try to calculate one to use. It does this by trying to fit every column into the width of the grid - this property dictates the minimum column width that will be used in this case and also applies to resizing columns via a pinch gesture.
 
 @warning *Important:* This method has been deprecated in preference of `defaultColumnStyle.minimumSize`.*/
@property (nonatomic, retain) NSNumber *minimumColWidth __attribute__((deprecated("Use defaultColumnStyle.minimumSize instead.")));

/** Indicates whether the grid will alpha blend the style colors.
 
 An example of where color layering occurs is when you have a defaultRowStyle that has a red background color and a column style that has a blue background color. If the blue background color had an alpha of 1 then no blending will take place, but an alpha of less than 1 blends so that we see the red color 'beneath' the blue color. If this property is `NO` then, then the color that is 'on top' in the layering will be used without blending with the 'beneath' colors (in the example above we would see a blue background color).*/
@property (nonatomic, assign) BOOL enableBlending;

/** The default arrow image that will be used when indicating the directions that a column/row can be dragged in after initating a long-press gesture.
 
 @warning *Important* The arrow supplied should point right. The top, left and bottom arrow images will be supplied by rotating this image as though it were pointing right initially.*/
@property (nonatomic, retain) UIImage              *defaultArrowImage;

#pragma mark -
#pragma mark Configuring a ShinobiGrid
/** @name Configuring a ShinobiGrid*/

/** Returns a reusable ShinobiGrid cell object located by its identifier.*/
- (id) dequeueReusableCellWithIdentifier:(NSString *) identifier;

/** This boolean value dictates the course of action to take if conflicting row and column styles are found. If set to `YES`, then the row style will take priority over the column style. If set to `NO` then the oppostie is true. The default value is `NO` (column styles take priority by default). 
 
 If you set the row at index 0 to have a `backgroundColor` of red, and the column at index 0 to have a `backgroundColor` of blue, then the cell at `gridCoord` {0,0} is being told to have a `backgroundColor` of red and blue. Setting this property to YES in this instance would mean that the row style (red background) will be appled.*/
@property (nonatomic, assign) BOOL                 rowStylesTakePriority;

/** Controls the manner in which the gridlines are displayed in this grid. 
 
 If this property is set to `SGridLinesVerticalOnTop` then the vertical gridlines will be drawn over the top of the horizontal gridlines. The opposite is true if this property is set to `SGridLinesHorizontalOnTop`. */
@property (nonatomic, assign) SGridLinesOnTop      linesOnTop;

/** This method freezes all columns to the left of (and including) the column at index `colIndex`. Note that if a cell belongs to both a frozen row and frozen column that it will not be scrollable in any direction.
 
 @param colIndex The index of the column that should be frozen, along with all columns that have a column index less than `colIndex`.
 
 @warning *Important:* This method has been deprecated in preference of the numberOfFrozenCols property.*/
- (void)               freezeColsToTheLeftOfAndIncludingIndex:(NSInteger)  colIndex __attribute__((deprecated("Use numberOfFrozenCols instead.")));

/** This method freezes all rows above (and including) the supplied row. Note that if a cell belongs to both a frozen row and frozen column that it will not be scrollable in any direction.
 
 @param row The row that should be frozen, along with all rows that appear above it in the grid.
 
 @warning *Important:* This method has been deprecated in preference of the numberOfFrozenRows property.*/
- (void)               freezeRowsAboveAndIncludingRow:(SGridRow) row __attribute__((deprecated("Use numberOfFrozenRows instead.")));

/**
 Property states how many columns should be frozen. The columns are frozen from
 the left hand side of the grid.
 The default value is 0, which represents there being no frozen columns.
 */
@property (nonatomic, assign) NSUInteger numberOfFrozenColumns;

/**
 Property states how many rows should be frozen. The rows are frozen from
 the top of the grid downwards.
 The default value is 0, which represents there being no frozen rows.
 */
@property (nonatomic, assign) NSUInteger numberOfFrozenRows;


/** Dictates whether this grid's columns can be resized or not. 
 
 If canResizeColumnsViaPinch is `YES`, then a user can pinch two columns to resize them. Default value is `NO`. 
 
 @warning *Important* Having this value set to `YES` means that the grid has an internal pinch gesture recogniser that is enabled. Setting this property to `NO` disables this gesture recogniser.
 */

@property (nonatomic, assign) BOOL                  canResizeColumnsViaPinch;

#pragma mark -
#pragma mark Selection of Cells

/** @name Selection of Cells*/

/** Dictates whether this grid can be single tapped or not.
 
 If canSelectViaSingleTap is `YES`, then a user can single tap grid cells and section headers. Tapping a cell triggers the shinobiGrid:willSelectCellAtCoord: delegate call. Tapping a section header collapses the section. Default value for this property is `YES`.
 
 Having this value set to `YES` means that the grid has an internal single tap gesture recogniser that is enabled. Setting this property to `NO` disables this gesture recogniser.
 
 @warning *Important:* This method has been deprecated in preference of `singleTapEventMask`.
 */

@property (nonatomic, assign) BOOL                  canSelectViaSingleTap __attribute__((deprecated ("Use singleTapEventMask instead")));

/** Controls the cell selection mode of the grid.
 
 `SGridSelectionModeCellSingle` means that by default the user can only select one cell at a time through gestures. When selecting a cell in this mode an attempt to deselect all currently selected cells will be made.
 `SGridSelectionModeCellMulti` means that by default the user can select multiple cells through gestures (no attempt to deselect currently selected cells will be made).
 `SGridSelectionModeRowSingle` means that by default the user can only select one row at a time through gestures. When selecting a row in this mode an attempt to deselect all currently selected cells will be made.
 `SGridSelectionModeRowMulti` means that by default the user can select multiple rows through gestures (no attempt to deselect currently selected cells will be made).
 `SGridSelectionModeNone` means that no selection will take place as a result of a recognised gesture.
 
 */
@property (nonatomic, assign) SGridSelectionMode selectionMode;

/** Prevents single-row deselection. When the grid is in single-row selection mode, this will prevent the user from deselecting the selected row.
 * Defaults to NO.
 */
@property (nonatomic, assign) BOOL preventSingleRowDeselection;

/** Return an array of grid coordinates of all the currently selected (and visible) cells.
 
 If no cells are currently selected then returns an empty array. Grid coordinates representing cells that are not visible are not returned.
 
 @return NSArray of SGridCoord objects that locate all the selected, visible cells in the grid.*/
- (NSArray*) selectedCellGridCoords;

/** Return an array of NSValue objects that represent the currently selected rows in the grid.
 
 @return NSArray of NSValue objects that encode SGridRow structs indicating the currently selected rows.*/
- (NSArray *) selectedRows;

/** Replaces the currently selected rows with a new NSArray of selected rows.
 
 This results in all the currently selected rows being deselected, and then all the rows in newSelectedRows being set as selected by calling setRow:asSelected:animated: on all of them.
 
 @param newSelectedRows An NSArray of NSValue objects (that contain SGridRow structs) to be marked as selected.
 @param animated `YES` if the clear of old selected rows and the selection of the new rows should be animated.*/
- (void) setSelectedRows:(NSArray*) newSelectedRows animated:(BOOL) animated;

/** Calls setSelectedRows:animated: with `animated == NO`.*/
- (void) setSelectedRows:(NSArray *)newSelectedRows;

/** Set an entire row in this grid as being selected/deselected. 
 
 Using this method results in the will/did select/deselect delegate callback methods being called. The should delegate callbacks will not be called.
 
 @warning *Important* Using this method ignores the selectionMode property, meaning that no automatic cell/row deselection will occur.
 
 @param row The row to set as selected/deselected.
 @param isSelected `YES` if the row should be set as selected.
 @param animated `YES` if this row's selection change should be animated.*/
- (void) setRow:(SGridRow) row asSelected:(BOOL) isSelected animated:(BOOL)animated;

/** Set all the currently selected cells to deselect.
 
 @param animate A boolean that controls if the clearing of the selected cells should be animated or not.*/
- (void) clearAllSelectedCellsWithAnimation:(BOOL) animate;

/** Dictates whether this grid can be edited or not. 
 
 If canEditCellsViaDoubleTap is `YES`, then a user can double tap a cell to edit its contents. Default value is `NO`.
 
 See the `shinobiGrid:didFinishEditingCell:` method of the SGridDelegate protocol for a means of intercepting user's changes to cell content.
 
 Having this value set to `YES` means that the grid has an internal double tap gesture recogniser that is enabled. Setting this property to `NO` disables this gesture recogniser.
 
 @warning *Important:* This method has been deprecated in preference of `doubleTapEventMask`.
 */
@property (nonatomic, assign) BOOL                 canEditCellsViaDoubleTap __attribute__((deprecated ("Use doubleTapEventMask instead")));


/** A Boolean value that determines whether directional lock disallows
 * diagnonal panning.
 *
 * This property only takes effect if directionalLockEnabled is YES.
 *
 * If this property is NO, scrolling behaves as dictated by
 * directionalLockEnabled.
 *
 * If this property is YES and the user begins dragging, the scroll view
 * disables scrolling in the other direction. If the drag direction is
 * diagonal, then the grid will lock in the most dominant direction.
 *
 * The default value is NO.
 */
@property (nonatomic, assign) BOOL directionalLockAllowDiagonalPanning;

#pragma mark -
#pragma mark Accessing Cells and Cell Visibility
/** @name Accessing Cells and Cell Visibility*/
/** Returns the cell that belongs to `colIndex` and `row`. Use this to retrieve a cell at a given coordinate.
 
 @warning *Important* Note that this method will only retrieve cells that are currently visible in the grid. If an attempt is made to retrieve a cell that is outside the bounds of the grid, nil will be returned. 
 
 @param colIndex The index of the column that the cell should belong to.
 @param row The row that the cell should belong to.
 
 @return An object representing the cell at grid coordinate {`colIndex`, `row`}.*/
- (SGridCell *)        visibleCellAtCol:(NSInteger) colIndex andRow:(SGridRow)row;

/** Returns an `NSArray` of `NSNumber` objects. Each `NSNumber` object represents a currently visible `colIndex`. Use this function to query which columns are currently visible in the grid. */
- (NSArray *)          visibleColumnIndexes;

/** Returns an `NSArray` of `NSValue` objects. Each `NSValue` object represents a currently visible `row` - the `SGridRow` struct can be retrieved from an `NSValue` object by first providing a struct variable such as `SGridRow visibleRow`, and then using the `getValue:` method of the `NSValue` object like so - `[rowValueObject getValue:&visibleRow]`. Use this function to query which rows are currently visible within the grid.*/
- (NSArray *)          visibleRows;

#pragma mark -
#pragma mark Row Utility Functions
/** This function will return the next row down.
 
 @warning *Important* This function is purely a utility function and has no bounds checking in relation to the grid. If you ask it to return the next row down from the very last row in the grid, it will return what would be the next row down regardless of the fact that the returned row does not exist in the grid.
 
 @param rowToStepDownFrom The row that will be stepped down from in order to find the next row.
 @return The row resulting from incrementing `rowToStepDownFrom` by one place.*/
- (SGridRow) findRowAfterRow:(SGridRow) rowToStepDownFrom;

/** This function will return the next row up.
 
 @warning *Important* This function is purely a utility function and has no bounds checking in relation to the grid. If you ask it to return the next row up from the very first row in the grid, it will return what would be the next row up regardless of the fact that the returned row does not exist in the grid.
 
 @param rowToStepUpFrom The row that will be stepped up from in order to find the previous row.
 @return The row resulting from decrementing `rowToStepUpFrom` by one place.*/
- (SGridRow) findRowBeforeRow:(SGridRow) rowToStepUpFrom;

#pragma mark -
#pragma mark Drag and Drop
/** @name Dragging and Dropping Columns and Rows*/
/** A boolean that dictates whether the rows of this grid can be dragged and dropped by the user. 
 
 If set to YES then the user can touch and hold a cell to initiate the drag and drop of a row.
 
 ShinobiGrid has an internal long press gesture recogniser which is enabled if either this property or the canReorderColsViaLongPress property is set to YES. Setting both these properties to NO disables this gesture recogniser.
 
 @warning *Important:* This method has been deprecated in preference of `defaultPermittedDragDirection`.*/
@property (nonatomic, assign) BOOL canReorderRowsViaLongPress __attribute__((deprecated("Use defaultPermittedDragDirection instead.")));

/** A boolean that dictates whether the columns of this grid can be dragged and dropped by the user. 
 
 If set to YES then the user can touch and hold a cell to initiate the drag and drop of a column.
 
 ShinobiGrid has an internal long press gesture recogniser which is enabled if either this property or the canReorderRowsViaLongPress property is set to YES. Setting both these properties to NO disables this gesture recogniser.
 
 @warning *Important:* This method has been deprecated in preference of `defaultPermittedDragDirection`.*/
@property (nonatomic, assign) BOOL canReorderColsViaLongPress __attribute__((deprecated("Use defaultPermittedDragDirection instead.")));

/**
An enum that dictates whether the rows of this grid can be dragged and dropped
by the user.

If set to SGridDragDirectionBoth then the user can touch and hold a cell to
initiate the drag and drop of a row.

If set to SGridDragDirectionCol, only columns can be dragged.
If set to SGridDragDirectionRow, only rows can be dragged.
If set to SGridDragDirectionNone, nothing can be dragged.

@warning *Important* ShinobiGrid has an internal long press gesture recogniser
which is enabled if either this property is not SGridDragDirectionNone. Setting
this property to SGridDragDirectionNone disables this gesture recogniser.
*/
@property (nonatomic, assign) SGridDragDirection defaultPermittedDragDirection;


/** The color to use when tinting the grid, during a drag and drop operation.
  Defaults to nil, for no tint color. */
@property(nonatomic, retain) UIColor *tintColor;

#pragma mark -
#pragma mark Gesture Event Handling
/** @name Gesture Event Handling */

/** The type of event that the grid fires upon a single tap

 <code>typedef enum {<br>
     SGridEventNone   = 0,<br>
     SGridEventSelect = 1 << 0,<br>
     SGridEventEdit   = 1 << 1,<br>
 } SGridEvent;</code>

 SGridEvent is a bitmask, allowing you to specify multiple events for a single gesture.
 For example, singleTapEventMask = SGridEventSelect | SGridEventEdit
 will cause the grid to select and edit a cell on single tap.
 
 The grid may be configured to use either select or edit a cell on a single tap. 
 To disable the single tap gesture, set this property to `SGridEventNone`
 
 Default `SGridEventSelect` */
@property (nonatomic) SGridEvent singleTapEventMask;

/** The type of event that the grid fires upon a double tap

 See `singleTapEventMask`
 
 To disable the double tap gesture, set this property to `SGridEventNone`
 
 Default `SGridEventEdit` */
@property (nonatomic) SGridEvent doubleTapEventMask;


/* [Undocumented]
Handle a selection event on one or more cells.
 
 This method is called when one or more cells are selected via a gesture.
 The gesture that fires this depends on `singleTapEvent`.
 Subclass this method to provide your own implementation. */
- (void) handleSelectionEventOnCell:(SGridCell *)cellToSelect;

/* [Undocumented]
Handle an edit event on a grid cell.
 
 This method is called a cell is edited via a gesture.
 The gesture that fires this depends on `doubleTapEvent`.
 Subclass this method to provide your own implementation. */
- (void) handleEditEventOnCell:(SGridCell *)cellToEdit;

/* [Undocumented]
Handle a reorder event on a grid cell.
 
 This method is called when a cell is reordered via a gesture.
 The default implementation will select a cell, ready for reordering.
 Subclass this method to provide your own implementation.
 */
- (void) handleReorderEventOnCell:(SGridCell *)cellTriggeringReorder;

#pragma mark -
#pragma mark Reloading/Redrawing the ShinobiGrid
/** @name Reloading and Redrawing the ShinobiGrid*/
/** Reloads this ShinobiDataGrid object.
 
 This method reloads the grid by clearing all state and querying all data source and delegate methods.
 
 @warning *Important* This is the only method from the Reload and Redraw variety that forces a recheck of column widths and row heights and is therefore the most expensive of these methods due to the need to reposition all grid elements.*/
- (void)               reload;

/** Reloads the data for the specified rows.
 
 This forces a query of your data source for all visible columns in the supplied rows. This method also triggers a redraw of the specified rows as per redrawRows:
 
 @warning *Important* This does not update row heights or query number of rows, sections or columns. If you wish to update dimensions of the grid you must use `reload`.
 
 @param rows An array of NSValue objects that contain SGridRow structs representing the rows to be redrawn.*/
- (void) reloadRows:(NSArray*) rows;

/** Reloads the data for the columns at the specified indices.
 
 This forces a query of your data source for all visible rows in the columns at the supplied indices. This method also triggers a redraw of the specified columns as per redrawColumns:
 
 @warning *Important* This does not update column widths or query number of rows, sections or columns. If you wish to update dimensions of the grid you must use `reload`.
 
 @param columns An array of SDataGridColumn objects representing the columns to be redrawn.*/
- (void) reloadColsAtIndices:(NSArray*) colIndices;

/** Redraws the specified rows.
 
 This causes the rows in question to have their styles rebuilt and reapplied (according to the grid's style heirarchy rules). This includes querying any delegate methods responsible for style. This method does not query the grid's data source.
 
 @warning *Important* This does not update row heights or query number of rows, sections or columns. If you wish to update dimensions of the grid you must use `reload`.
 
 @param rows An array of NSValue objects that contain SGridRow structs representing the rows to be redrawn.*/
- (void) redrawRows:(NSArray*) rows;

/** Redraws the specified columns.
 
 This causes the columns in question to have their styles rebuilt and reapplied (according to the grid's style heirarchy rules). This includes querying any delegate methods responsible for style. This method does not query the grid's data source.
 
 @warning *Important* This does not update column widths or query number of rows, sections or columns. If you wish to update dimensions of the grid you must use `reload`.
 
 @param columns An array of NSNumber objects that represent the indices of the columns to be redrawn. The method `intValue` will be used to extract the index from each NSNumber object.*/
- (void) redrawColsAtIndices:(NSArray*) colIndices;

/** Controls whether or not your app should wait for the grid to finish laying out before appearing. If set to `YES` the layout of the grid will be pushed to the beginning of your app's next run loop - the effect of this is that your app will appear without the grid and the grid will add itself to the view when it has finished laying out. Default value is `NO`.*/
@property (nonatomic, assign) BOOL                 deferredLayout;

#pragma mark -
#pragma mark Querying Cols/Rows/Sections

/** Returns the total number of columns that the grid currently has.
 
 @return NSUInteger that represents the number of columns for this grid.*/
- (NSUInteger) numberOfColumns;
/** Returns the total number of rows that the grid currently has in a particular section. Returns `NSNotFound` if `sectionIndex` does not exist in the grid.
 
 @param sectionIndex The index of the section for which you are requesting the number of rows.
 @return NSUInteger that represents the number of rows for the section at `sectionIndex` for this grid.*/
- (NSUInteger) numberOfRowsForSection:(NSInteger) sectionIndex;
/** Returns the number of sections that the grid currently has.
 
  @return NSUInteger that represents the number of sections for this grid.*/
- (NSUInteger) numberOfSections;

#pragma mark -
#pragma mark Sections

/** Sets a given section of this ShinobiGrid as collapsed or expanded.
 
 Setting an already expanded section to expand (or a collapsed section to collapse) has no effect.
 
 @param index The index of the section that is to be collapsed/expanded.
 @param collapsed A bool that indicates what the section should be set to - YES collapses the section and NO expands the section.*/
- (void) setSectionAtIndex:(NSUInteger)index asCollapsed:(BOOL)collapsed;

/** Returns whether or not a section in this ShinobiGrid is currently collapsed.
 
 @param index The index of the section to be checked for collapse.
 @return A bool that indicates whether the section at `index` is collapsed. YES if collapsed state. NO if expanded state.*/
- (BOOL) sectionAtIndexIsCollapsed:(NSUInteger)index;

#pragma mark -
#pragma mark Delegate, Data Source and License Key
/** @name Managing the Delegate and Data Source*/
/** The object that acts as the data source for the receving ShinobiGrid object.
 
 The data source must adopt the SGridDataSource protocol.

 @warning *Important* The datasource property is a *weak* reference to the grid's datasource. This means you must maintain a reference to it, to prevent prevent the datasource from being autoreleased / released by ARC.
 */
@property (nonatomic, assign) id <SGridDataSource> dataSource;

/** The object that acts as the delegate of the receiving ShinobiGrid object.
 
 The delegate must adopt the SGridDelegate protocol. The delegate is not retained.
 @warning *Important* The delegate property is a *weak* reference to the grid's delegate. This means you must maintain a reference to it, to prevent prevent the delegate from being autoreleased / released by ARC.
 */
@property (nonatomic, assign) id <SGridDelegate>   delegate;

/** This property is now deprecated. You should use the `licenseKey` property on the `ShinobiGrids` class instead.
 
 The License Key for this Grid
 
 A valid license key must be set before the grid will render */
@property (nonatomic, retain) NSString *licenseKey DEPRECATED_ATTRIBUTE;


#pragma mark -
#pragma mark Grid Version

/** @name Grid Version*/

/** @warning DEPRECATED in 2.7.0 - You should use `[ShinobiGrids getInfo]` instead. */
+ (NSString *) getInfo DEPRECATED_ATTRIBUTE;

/** @warning DEPRECATED in 2.7.0 - You should use `[ShinobiGrids getInfo]` instead. */
- (NSString *) getInfo DEPRECATED_ATTRIBUTE;

@end
