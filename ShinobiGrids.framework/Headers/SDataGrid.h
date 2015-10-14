//
//  SDataGrid.h
//  Dev
//
//  Created by  on 16/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDataGridSelectionMode.h"
#import "SDataGridLinesOnTop.h"
#import "SDataGridEventMask.h"

#import "SDataGridDataSource.h"
#import "SDataGridDelegate.h"

@class SDataGridCellStyle;
@class SDataGridLineStyle;
@class SDataGridColumn;
@class SDataGridRow;
@class SDataGridCell;
@class SDataGridTheme;
@class SDataGridPullToAction;

/** The ShinobiDataGrid (or data-grid) is a control to display tabular data. It is composed of rows which run horizontally and columns which run vertically. It inherits from UIScrollView and can (and should) therefore be treated as UIView object for layout.
 
 **Hint:** _More detail about configuration of the ShinobiDataGrid is available in the DataGridUserGuide._
  
 The data-grid is first configured by adding a number of column objects that represent the vertical configuration of the data-grid. Each column has a header, which typically indicates the nature of the data displayed within that column. The column header not only indicates the type of data that it displays, it also allows the user to interact with the column, enabling them to sort the data that it contains, drag to re-order or pinch to resize.
 
 Once the data-grid is configured, and ready to render, the rows will be loaded from the datasource. 
 
 The data-grid can optionally display grouped data within a number of sections. Each section has a header, which spans the entire width of the data-grid, and a number of rows. This can be used, for example, to group emails by date, or perhaps contacts by the first letter of their name.
 
 In order to use the data-grid you will typically perform the following tasks:
 
 Add some columns to the data-grid – these define the columns that are rendered by the data-grid at runtime.
 Set the data-grid dataSource property – this is used to provide data to the grid.
 (Optionally) Set the data-grid delegate property – this is used to respond to a user’s interactions with the data-grid.
 
 A ShinobiDataGrid object must have an associated object that acts as the data source (which must conform to the SDataGridDataSource protocol). The data source provides the necessary information to populate the grid given the structure of columns, and the content to be displayed within each cell. The datasource concerns itself solely with the data model, and issues relating to the style of the data-grid are controlled through the delegate.
 
 The delegate of the ShinobiDataGrid object must conform to the SDataGridDelegate protocol and can be used to provide styling and receive notifications about data-grid activity. You need only provide a delegate for your ShinobiDataGrid object if you wish to provide a style for a specific element of the grid. If you wish to style the data-grid in a uniform manner (every gridline will be styled identically etc) then the properties such as defaultCellStyleForRows, defaultCellStyleForAlternateRows, etc are designed for this purpose. As such it is not necessary for a ShinobiDataGrid to have a delegate.
 
 There are three preset themes provided, which can be used to provide a base style to the grid - you may or may not wish customize these further. The SDataGridTheme class manages these themes and contain more information on how to change the initial theme. The default theme is called `iOS` and is designed to blend nicely with the Apple UIkit defaults.
 
 The data-grid only creates the elements that it requires to render the data that is currently visible on the device’s screen. As an example, when the user scrolls the grid vertically, the cells that scroll beyond the upper bounds of the screen are not destroyed, instead these cells are re-positioned at the bottom of the scrolling container so that the come into view once more. The same principle applies to horizontal or diagonal scrolling.
 
 The data-grid handles the process of pooling and recycling cells, and with typical data-grid usages you don’t need to be concerned with the way that cells are recycled. However, you should keep this process in mind – if for example, you make changes to the state of a visible cell; you cannot expect the state to be the same if the cell is scrolled off-screen then back on again. Indeed, you cannot expect it to be the same cell!
 
 Refreshing the content of the data-grid may be required for a number of reasons - style changes, data changes or both! Since each comes with it's own cost that may vary per implementation, the data-grid offers number of alterntives to a full reload. We recommend only performing the minimum type of reload required to reduce the overhead of the data-grid operating in your app.
 
 @warning *Important* The dataSource property and delegate property are both *weak* references to the objects. To prevent them being autoreleased / released by ARC you must maintain references to the objects you provide.
 
 */

@interface ShinobiDataGrid : UIScrollView {
}

#pragma mark -
#pragma mark Initialization
/** @name Initialization

Use these methods to initialize a DataGrid */

/** Initialize a DataGrid with a frame to display in.

@param frame Initial frame of the DataGrid. */
- (id) initWithFrame:(CGRect)frame;

/** Initialize a DataGrid from an NSCoder.

@param aDecoder An NSCoder to decode with.
*/
- (id) initWithCoder:(NSCoder *)aDecoder;

/** Initialize a DataGrid with an initial set of columns.

@param columns An array of SDataGridColumn objects.
*/
- (id) initWithColumns:(NSArray *)columns;

#pragma mark -
#pragma mark Column Configuration
/** @name Column Configuration
 
 Using these methods to change the columns that belong to the grid does not result in a reload of the grid - any changes made to the columns of this grid will only take effect when a new layout/reload has been initiated.
 
 @warning *Important* The `displayIndex` of the columns being added always takes precedence over the order in which you add them.*/

/** Add an SDataGridColumn object to this grid. The column is appended to the end of columns.
  
 @param col The column to add to this grid.*/
- (void) addColumn:(SDataGridColumn*) col;

/** Add an array of SDataGridColumn objects. 
 
 @param cols The NSArray of SDataGridColumn objects to add to this grid.*/
- (void) addColumnsFromArray:(NSArray*) cols;

/** Remove a SDataGridColumn object from this grid based on its index.
 
 @param indexToRemove*/
- (void) removeColumnAtIndex:(NSInteger) indexToRemove;

/** Remove a specific SDataGridColumn object from the grid.
 
 @param col The SDataGridColumn object to be removed from the grid.*/
- (void) removeColumn:(SDataGridColumn*) col;
- (void) removeAllColumns;

/** The columns on the datagrid. This returns an array of SDataGridColumn objects.
 Assigning to this array replaces any existing columns on the grid with the new contents of the array.
 */
@property(nonatomic, retain) NSArray *columns;

#pragma mark -
#pragma mark Changing a ShinobiDataGrid's Default Styles
/** @name Changing a ShinobiDataGrid's Default Styles*/

/** This property is the default style that will be applied to all gridlines that belong this this ShinobiDataGrid object. 
 
 Any style applied to a gridline via the delegate object will take priority over this property.*/
@property (nonatomic, retain) SDataGridLineStyle       *defaultGridLineStyle;

/** This property represents the style that will be applied to all section headers in this grid. 
 
 To specify individual styles for each (or a particular) section header then see the `shinobiGrid:headerStyleForSectionAtIndex:` method of SDataGridDelegate. Note that a style specified with the delegate method will take priority over this property.*/
@property (nonatomic, retain) SDataGridSectionHeaderStyle *defaultSectionHeaderStyle;

/** The style that will be applied to the header row in this grid.
 
 The header row is unaffected by defaultRowStyle, defaultAlternateRowStyle and column styles. The header row style heirarchy is not subject to alpha blending as per blendLayeredStyleBackgroundColors and blendLayeredStyleTextColors.*/
@property (nonatomic, retain) SDataGridCellStyle *defaultCellStyleForHeaderRow;

/** The height that the header row in this grid will have.
 
 The header row is unaffected by defaultRowHeight and the delegate row height method.*/
@property (nonatomic, retain) NSNumber *defaultHeaderRowHeight;

/** This property sets a default cell style that will be used for all cells in this grid. Use this property to quickly set a base cell style for the grid. 
 
 This property will be overriden by, or blended with, any style that is more specific, such as styles assigned in the delegate methods or styles assigned when returning a cell in the datasource method.*/
@property (nonatomic, retain) SDataGridCellStyle     *defaultCellStyleForRows;

/** This property can be used to supply a row style that will be used for all odd numbered row indices. Alternation of styles restarts with each new section.
 
 This property will be overriden by, or blended with, any style that is more specific, such as styles assigned in the delegate methods or styles assigned when returning a cell in the datasource method.*/
@property (nonatomic, retain) SDataGridCellStyle   *defaultCellStyleForAlternateRows;

/** The default height to be used for rows in this grid. Setting `nil` means that some default height will be used. */
@property (nonatomic, retain) NSNumber *defaultRowHeight;

/** The default width to be used for columns in this grid. Setting `nil` means that some default width will be used. */
@property (nonatomic, retain) NSNumber *defaultColWidth;

/**
 The minimum allowable height of the rows in the grid.
 
 If the defaultRowHeight is `nil` and the SDataGridDelegate doesn't implement shinobiDataGrid:heightForRowAtIndex:inSection:
 then the grid will calculate a row height. It will attempt to fit all the rows
 within the height of the grid. In order that the grid rows aren't squashed
 set a minimumRowHeight to be used as part of this calculation.
*/
@property (nonatomic, retain) NSNumber *minimumRowHeight;

/** 
 The default minimum width of the columns in the grid.
 
 If the defaultColWidth is `nil`, and the SDataGridColumn doesn't have a specified
 width then the grid will attempt to calculate the column widths which fit all
 columns within the grid's frame. In order that columns don't get too squashed
 you can set the minimumColWidth. A SDataGridColumn also has a minimumWidth property
 which is used in preference to this grid-global value.
 
 The minimumWidths are also used when column resizing via a pinch gesture is
 enabled.
*/
@property (nonatomic, retain) NSNumber *minimumColWidth;

/** Indicates whether the grid will alpha blend the style colors.
 
 An example of where color layering occurs is when you have a defaultRowStyle that has a red background color and a column style that has a blue background color. If the blue background color had an alpha of 1 then no blending will take place, but an alpha of less than 1 blends so that we see the red color 'beneath' the blue color. If this property is `NO` then, then the color that is 'on top' in the layering will be used without blending with the 'beneath' colors (in the example above we would see a blue background color).*/
@property (nonatomic, assign) BOOL enableBlending;

#pragma mark -
#pragma mark Configuring a ShinobiDataGrid
/** @name Configuration of a ShinobiDataGrid */

/** Controls the manner in which the gridlines are displayed in this grid. 
 
 If this property is set to `SDataGridLinesVerticalOnTop` then the vertical gridlines will be drawn over the top of the horizontal gridlines. The opposite is true if this property is set to `SDataGridLinesHorizontalOnTop`. */
@property (nonatomic, assign) SDataGridLinesOnTop      linesOnTop;

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

/** Controls the cell selection mode of the grid. 
 
 `SDataGridSelectionModeCellSingle` means that by default the user can only select one cell at a time through gestures. When selecting a cell in this mode an attempt to deselect all currently selected cells will be made.
 `SDataGridSelectionModeCellMulti` means that by default the user can select multiple cells through gestures (no attempt to deselect currently selected cells will be made). 
 `SDataGridSelectionModeRowSingle` means that by default the user can only select one row at a time through gestures. When selecting a row in this mode an attempt to deselect all currently selected cells will be made.
 `SDataGridSelectionModeRowMulti` means that by default the user can select multiple rows through gestures (no attempt to deselect currently selected cells will be made). 
 `SDataGridSelectionModeNone` means that no selection will take place as a result of a recognised gesture.
 
 */
@property (nonatomic, assign) SDataGridSelectionMode selectionMode;

/** The default style to be used upon row/cell selection.*/
@property (nonatomic, retain) SDataGridCellStyle *defaultCellStyleForSelectedRows;

/** Return an array of grid coordinates of all the currently selected (and visible) cells.
 
 If no cells are currently selected then returns an empty array.
 
 @return NSArray of SDataGridCoord objects that locate all the selected, visible cells in the grid.*/
- (NSArray*) selectedCellCoordinates;

/** Return an array of SDataGridRow objects that represent the currently selected rows in the grid.
 
 @return NSArray of SDataGridRow objects indicating the currently selected rows.*/
- (NSArray *) selectedRows;

/** Replaces the currently selected rows with a new NSArray of selected rows.
 
 This results in all the currently selected rows being deselected, and then all the rows in newSelectedRows being set as selected by calling setRow:asSelected:animated: on all of them.
 
 @param newSelectedRows An NSArray of SDataGridRow objects to be marked as selected.
 @param animated `YES` if the clear of old selected rows and the selection of the new rows should be animated.*/

- (void) setSelectedRows:(NSArray*) newSelectedRows animated:(BOOL)animated;

/** Calls setSelectedRows:animated: with `animated == NO`.*/
- (void) setSelectedRows:(NSArray *)newSelectedRows;

/** Set an entire row in this grid as being selected/deselected.
 
 @warning *Important* Using this method ignores the selectionMode property, meaning that no automatic cell/row deselection will occur.
 
 @param row The row to set as selected/deselected.
 @param isSelected `YES` if the row should be set as selected.
 @param animated `YES` if this row's selection change should be animated.*/
- (void) setRow:(SDataGridRow*) row asSelected:(BOOL) isSelected animated:(BOOL)animated;

/** Set all the currently selected cells to deselect.
 
 @param animate A boolean that controls if the clearing of the selected cells should be animated or not.*/
- (void) clearSelectionWithAnimation:(BOOL) animate;

#pragma mark - Pull To Action

/** @name Pull To Action */

/** Whether the pull to action component should be shown.
 
 When the `showPullToAction` property is set to `NO`, it will be hidden and its `scrollView` property will be set to `nil`.
 
 Defaults to `NO`*/
@property (nonatomic, assign) BOOL showPullToAction;

/** The pull to action component is triggers an event when the grid is pulled down past a certain threshold.
 
 By default the Pull To Action control will appear from underneath your lowest frozen row (or header row if you have no
 frozen rows) and trigger a `reload` when pulled.
 
 @warning By default the Pull To Action is hidden. To enable it set the `showPullToAction` property to `YES`. */
@property (nonatomic, retain) SDataGridPullToAction *pullToAction;

#pragma mark -
#pragma mark Gesture Event Handling
/** @name Gesture Event Handling */
/** The type of event that the grid fires upon a single tap

 <code>typedef enum {<br>
     SDataGridEventNone   = 0,<br>
     SDataGridEventSelect = 1 << 0,<br>
     SDataGridEventEdit   = 1 << 1,<br>
 } SDataGridEvent;</code>

 SDataGridEvent is a bitmask, allowing you to specify multiple events for a single gesture.
 For example, singleTapEventMask = SDataGridEventSelect | SDataGridEventEdit
 will cause the grid to select and edit a cell on single tap.
 
 The grid may be configured to use either select or edit a cell on a single tap. 
 To disable the single tap gesture, set this property to `SDataGridEventNone`
 
 Default `SDataGridEventSelect` */
@property (nonatomic) SDataGridEvent singleTapEventMask;

/** The type of event that the grid fires upon a double tap

 See `singleTapEvent`
 
 To disable the double tap gesture, set this property to `SDataGridEventNone`
 
 Default `SDataGridEventEdit` */
@property (nonatomic) SDataGridEvent doubleTapEventMask;

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

/** Returns the cell at `coord`. Use this to retrieve a cell at a given coordinate.
 
 This method is unable to retrieve header cells. In order to do this use see the headerCell property of SDataGridColumn.
 
 @warning *Important* Note that this method will only retrieve cells that are currently visible in the grid. If an attempt is made to retrieve a cell that is outside the bounds of the grid, nil will be returned.
 
 @param coordinate The coordinate of the cell.
 
 @return An object representing the cell at grid coordinate `coordinate`.*/
- (SDataGridCell *) visibleCellAtCoordinate:(SDataGridCoord *)coordinate;

/** Returns an `NSArray` of SDataGridColumn objects. Use this method to query which columns are currently visible in the grid. 
 
 @return NSArray containing SDataGridColumn objects representing the currently visible range of columns.*/
- (NSArray *)          visibleColumns;

/** Returns an `NSArray` of SDataGridRow objects. Use this method to query which rows are currently visible within the grid.
 
 @return NSArray containing SDataGridRow objects representing the currently visible range of rows.*/
- (NSArray *)          visibleRows;

#pragma mark -
#pragma mark Drag and Drop
/** @name Dragging and Dropping Columns and Rows*/
/**
 Controls whether the user can instantiate the drag and drop of rows from a long press on the grid's body cells (anything other than the header row).
 
 A drag and drop of columns can be instantiated from a long press on the header row, which can be tailored on the SDataGridColumn objects. You can completely override all drag and drop behaviour using the delegate method shinobiDataGrid:permittedDragDirectionForCellAtCoordinate:.
*/
@property (nonatomic, assign) BOOL canReorderRows;


/** The color to use when tinting the grid, during a drag and drop operation.
  Set to nil or -[UIColor clearColor] for no tint color.
  Defaults to -[UIColor blackColor]. */
@property(nonatomic, retain) UIColor *tintColor;

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
 
 @param rows An array of SDataGridRow objects representing the rows to be redrawn.*/
- (void) reloadRows:(NSArray*) rows;

/** Reloads the data for the specified columns.
 
 This forces a query of your data source for all visible rows in the supplied columns. This method also triggers a redraw of the specified columns as per redrawColumns:
 
 @warning *Important* This does not update column widths or query number of rows, sections or columns. If you wish to update dimensions of the grid you must use `reload`.
 
 @param columns An array of SDataGridColumn objects representing the columns to be redrawn.*/
- (void) reloadColumns:(NSArray*) columns;

/** Redraws the specified rows.
 
 This causes the rows in question to have their styles rebuilt and reapplied (according to the grid's style heirarchy rules). This includes querying any delegate methods responsible for style. This method does not query the grid's data source.
 
 @warning *Important* This does not query row heights or query number of rows, sections or columns. If you wish to update dimensions of the grid you must use `reload`.
 
 @param rows An array of SDataGridRow objects representing the rows to be redrawn.*/
- (void) redrawRows:(NSArray*) rows;

/** Redraws the specified columns.
 
 This causes the columns in question to have their styles rebuilt and reapplied (according to the grid's style heirarchy rules). This includes querying any delegate methods responsible for style. This method does not query the grid's data source.
 
 @warning *Important* This does not query column widths or query number of rows, sections or columns. If you wish to update dimensions of the grid you must use `reload`.
 
 @param columns An array of SDataGridColumn objects representing the columns to be redrawn.*/
- (void) redrawColumns:(NSArray*) columns;

#pragma mark -
#pragma mark Querying Rows/Sections
/** @name Querying Rows and Sections */

/** Returns the total number of rows that the grid currently has in a particular section. Returns `NSNotFound` if `sectionIndex` does not exist in the grid.
 
 @param sectionIndex The index of the section for which you are requesting the number of rows.
 @return NSUInteger that represents the number of rows for the section at `sectionIndex` for this grid.*/
- (NSUInteger) numberOfRowsForSection:(NSInteger) sectionIndex;
/** Returns the number of sections that the grid currently has.
 
 @return NSUInteger that represents the number of sections for this grid.*/
- (NSUInteger) numberOfSections;

/** Returns whether a row references a valid cell in this grid.

 @param row   Row to test validity of.
 @return BOOL that represents whether the row is valid.*/
- (BOOL) isValidDataGridRow:(SDataGridRow *)row;

#pragma mark -
#pragma mark Sections Collapsing
/** @name Section Collapsing */

/** Sets a given section of this ShinobiDataGrid as collapsed or expanded.
 
 Setting an already expanded section to expand (or a collapsed section to collapse) has no effect.
 
 @param index The index of the section that is to be collapsed/expanded.
 @param collapsed A bool that indicates what the section should be set to - YES collapses the section and NO expands the section.*/
- (void) setSectionAtIndex:(NSUInteger)index asCollapsed:(BOOL)collapsed;

/** Returns whether or not a section in this ShinobiDataGrid is currently collapsed.
 
 @param index The index of the section to be checked for collapse.
 @return A bool that indicates whether the section at `index` is collapsed. YES if collapsed state. NO if expanded state.*/
- (BOOL) sectionAtIndexIsCollapsed:(NSUInteger)index;

#pragma mark -
#pragma mark Delegate, Data Source and License Key
/** @name Datasource, Delegate and License Key */

/** @name Managing the Delegate and Data Source*/
/** The object that acts as the data source for the receving ShinobiDataGrid object.
 
 The data source must adopt the SDataGridDataSource protocol. The data source is not retained.*/
@property (nonatomic, assign) id <SDataGridDataSource> dataSource;

/** The object that acts as the delegate of the receiving ShinobiDataGrid object.
 
 The delegate must adopt the SDataGridDelegate protocol. The delegate is not retained.*/
@property (nonatomic, assign) id <SDataGridDelegate>   delegate;

/** This property is now deprecated. You should use the `licenseKey` property on the `ShinobiDataGrids` class instead.
 
 The License Key for this Grid
 
 A valid license key must be set before the grid will render.  */
@property (nonatomic, assign) NSString *licenseKey DEPRECATED_ATTRIBUTE;


#pragma mark -
#pragma mark Grid Version
/** @name Grid Version*/

/** @warning DEPRECATED in 2.7.0 - You should use `[ShinobiDataGrids getInfo]` instead. */
+ (NSString *) getInfo DEPRECATED_ATTRIBUTE;

/** @warning DEPRECATED in 2.7.0 - You should use `[ShinobiDataGrids getInfo]` instead. */
- (NSString *) getInfo DEPRECATED_ATTRIBUTE;

#pragma mark - Theming

/** Applies a theme to the grid.

 A ShinobiDataGrid will take all of its UI configuration - colors, fonts etc -
 from the SDataGridTheme object. If a theme is not explicitly set on a grid, an
 SDataGridInitialThemeiOS will be applied by default on grids running on
 versions of iOS prior to iOS 7, otherwise an instance of
 SDataGridInitialThemeiOS7 will be applied.

 This method applies the styling properties of the given theme to the grid,
 overwriting any changes which you have made to sub-objects on the grid.
 After this, changes made to individual objects will have precendence - for
 example setting the gridline color via the delegate. To reset the styling
 configuration on a grid to a theme, alloc a new theme and call `applyTheme:`
 - this will clear all styling configuration from the grid and set it to the
 theme defaults.
 */
- (void)applyTheme:(SDataGridTheme *)theme;

@end
