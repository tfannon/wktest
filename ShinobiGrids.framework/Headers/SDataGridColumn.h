//
//  SDataGridColumn.h
//
#import <Foundation/Foundation.h>

#import "SDataGridColumnSortOrder.h"
#import "SDataGridColumnSortMode.h"

@class SDataGridHeaderCell;
@class SDataGridCellStyle;

/**
 
 In order to render your data within the data-grid you need to add one or more columns of type SDataGridColumn. One of the most important functions of the columns is to specify the type of cells which are used. A cell must be a subclass of SDataGridCell, which provides the basic functionality required by the data-grid for pooling, and other ‘core’ features such as selection.
 
 Each column also specifies the header text which is displayed at the top of each column, title. You can also specify the type of cell used for the header by setting the `headerCellType` property.
 
 A user can sort the rows of the data-grid by tapping on the column headers. The sort behaviour is specified on a per-column basis by setting the sortMode property. This can have the following values:
 
 -	SDataGridSortModeNone – This indicates that the data-grid cannot be sorted by the data within this column.
 -	SDataGridSortModeBiState – This indicates that the data-grid can be sorted by the data within this column. When a column is in bi-state sort mode it toggles between an ascending and descending sort with each tap.
 -	SDataGridSortModeTriState – This indicates that the data-grid can be sorted by the data within this column. When a column is in tri-state sort mode it iterates through the following sort orders {ascending, descending, none}. A tri-state sort mode can be used for data that has a ‘natural’ sort order, allowing the user to sort the data-grid ascending or descending, then return it to its original sort order.
 
 The current sort order for a column can be retrieved from its `sortOrder` property. This can also be used to programmatically set the sort state of the data-grid. Column sorting is mutually exclusive, in other words, when the user taps to sort by a column, and other columns that are currently sorted have their `sortOrder` set to none. Changes in sort order can be detected by providing a delegate to the data-grid.
 
 */


@interface SDataGridColumn : NSObject {    
}

#pragma mark -
#pragma mark Creating a column
/** @name Creating a column */

/** A convenience method that returns an SDataGridColumn object that has been added to the autorelease pool using initWithTitle: */
+ (id) columnWithTitle:(NSString*) title;

/** A convenience method that returns an SDataGridColumn object that has been added to the autorelease pool using initWithTitle: and has the specified displayIndex */
+ (id) columnWithTitle:(NSString*) title displayIndex:(NSUInteger)displayIndex;

/** A convenience method that returns an SDataGridColumn object that has been added to the autorelease pool using initWithTitle:withCellType: */
+ (id) columnWithTitle:(NSString*) title cellType:(Class) cellType;

/** A convenience method that returns an SDataGridColumn object that has been added to the autorelease pool using initWithTitle:forProperty: */
+ (id) columnWithTitle:(NSString*) title forProperty:(NSString*)propertyKey;

/** A convenience method that returns an SDataGridColumn object that has been added to the autorelease pool using initWithTitle:forProperty:withCellType:withHeaderCellType: */
+ (id) columnWithTitle:(NSString*) title forProperty:(NSString*)propertyKey cellType:(Class) cellType headerCellType:(Class) headerCellType;

/** Returns an SDataGridColumn object with the specified title and a cell type of SDataGridTextCell.
 
 @param text The text you wish to set as the header's text.
 
 @return A new SDataGridColumn object that has the title specified.*/
- (id) initWithTitle:(NSString*)text;

/** Returns an SDataGridColumn object with the specified title and cell type.
 
 @param text The text you wish to set as the header's text.
 @param cellType The type of cells that this column will send to your data source method.
 
 @return A new SDataGridColumn object that has the title specified.*/
- (id) initWithTitle:(NSString*) text cellType:(Class) cellType;

/** Returns an SDataGridColumn object with the specified title, property Key and a cell type of SDataGridTextCell.
 
 @param text The text you wish to set as the header's text.
 @param propertyKey The key used to extract the the value for this column when used with the SDataGridDataSourceHelper.
 
 @return A new SDataGridColumn object that has the title specified.*/
- (id) initWithTitle:(NSString*) text forProperty:(NSString*)propertyKey;

/** Returns an SDataGridColumn object with the specified title, named property, cell type and header cell type.
 
 @param text The text you wish to set as the header's text.
 @param cellType The type of cells that this column will send to your data source method.
 @param propertyKey The key used to extract the the value for this column when used with the SDataGridDataSourceHelper.
 @param headerCellType The type of header cell that will be used for this column.
 @return A new SDataGridColumn object that has the title specified.*/
- (id) initWithTitle:(NSString*) text forProperty:(NSString*)propertyKey cellType:(Class) cellType headerCellType:(Class) headerCellType;

#pragma mark -
#pragma mark Referencing and ordering
/** @name Referencing and ordering */

/** The key used to extract the the value for this column when used with the SDataGridDataSourceHelper. */
@property (nonatomic, retain) NSString *propertyKey;

/** Represents the position that this column will be displayed at.
 
 This property takes precedence over the order in which you add the columns to the grid. A default value of `NSNotFound` is assigned when initializing a column. If `NSNotFound` is the displayIndex when this column is added to a grid then the count of the grid's current columns is automatically assigned to this property.
 
 @warning Note that display indices will be normalised. So setting display indices of {-101, 0, 0, 1, 2, -102, -1000} will result in normalised indices of {2, 3, 4, 5, 6, 1, 0}. */
@property (nonatomic, assign) NSInteger displayIndex;

/** An integer that you can use to identify SDataGridColumn objects in your application.
 */
@property(nonatomic) NSInteger tag;


#pragma mark -
#pragma mark Configuring the header
/** @name Configuring the header */

/** The title belonging to this SDataGridColumn. This will be rendered in the SDataGrid's header row.*/
@property (nonatomic, retain) NSString *title;

/** Provides access to the header cell for this column.
 
 Note that this method will only return a cell if the column in question is currently visible, otherwise nil is returned.*/
- (SDataGridHeaderCell *) headerCell;

/** Represents the type of cell that will be used to populate the header row of this column.
 
 If you do not set this then the type SDataGridHeaderCell will be assumed and used automatically.
 
 @warning The type used must be SDataGridHeaderCell or a subclass.*/
@property (nonatomic, assign) Class headerCellType;

/** Same as hasCellType: but for headerCellType. */
- (BOOL) hasHeaderCellType:(Class) headerCellType;

/** The style object that will be used for the header cell associated with this column.*/
@property (nonatomic, retain) SDataGridCellStyle *headerCellStyle;

#pragma mark -
#pragma mark Configuring the cell type
/** @name Configuring the cell type */

/** Represents the cell type that this column will contain. This controls the type of cell that will be returned to you in the datasource method -[SDataGridDataSource shinobiDataGrid:prepareCellForDisplay:atGridCoordinate:].
 
 If you do not set this then the type SDataGridCell will be assumed and set automatically.
 
 @warning The type used must be SDataGridCell or a subclass.*/
@property (nonatomic, assign) Class cellType;

/** Tests if this SDataGridColumn object has a specificed cell type.
 
 Returns YES if this column's cellType is the same as or inherits from cellTypeToTest. Otherwise returns NO.
 
 @param cellTypeToTest The type which this column will compare its cellType against.
 @return BOOL that indicates if this column has (or inherits from) the specified type.*/
- (BOOL) hasCellType:(Class) cellTypeToTest;

/** The style object that will be used for all cells associated with this column.*/
@property (nonatomic, retain) SDataGridCellStyle *cellStyle;


#pragma mark -
#pragma mark Setting the width
/** @name Setting the width */

/** Represents the width of this column. Setting `nil` means some default width will be used by the grid.
 
 Default for this property is `nil`.*/
@property (nonatomic, retain) NSNumber *width;

/** The minimum width for this column. This is used if auto-calculating the width of columns in the grid and when resizing the columns via a pinch gesture.
 
 Default for this property is `nil`.*/
@property (nonatomic, retain) NSNumber *minimumWidth;

/** Specifies whether or not this column is resizeable in response to a user's pinch gesture.
 
 Defaults to NO.
 */
@property (nonatomic, assign) BOOL canResizeViaPinch;

/** Controls if this column can be dragged and dropped via a long press on the header cell.
 
 If you wish to change how the dragging and dropping of rows works then see canReorderRows on ShinobiDataGrid.*/
@property (nonatomic, assign) BOOL canReorderViaLongPress;

#pragma mark -
#pragma mark Sorting column data
/** @name Sorting column data */

/** Represents the current sort order of this column.
 
 Tapping this column's header cell changes sortOrder according to the current sortMode. Tapping this column's header cell will return all other columns within the owning grid to having a sortOrder of SDataGridColumnSortOrderNone. Default value is SDataGridColumnSortOrderNone.*/
@property (nonatomic, assign) SDataGridColumnSortOrder sortOrder;

/** Controls how the sortOrder changes when this column's header cell is tapped.
 
 If set to SDataGridColumnSortModeNone, then sortOrder will never change from SDataGridColumnSortOrderNone as the user taps this column's header cell. If set to SDataGridColumnSortModeBiState, then this column will initially start with a default sortOrder of SDataGridColumnSortOrderNone and cycle between SDataGridColumnSortOrderAscending and SDataGridColumnSortOrderDescending with each subsequent tap on this column's header cell. If set to SDataGridColumnSortModeTriState, then this column will initially start with a default sortOrder of SDataGridColumnSortOrderNone and cycle between SDataGridColumnSortOrderAscending, SDataGridColumnSortOrderDescending and SDataGridColumnSortOrderNone with each subsequent tap on this column's header cell.*/
@property (nonatomic, assign) SDataGridColumnSortMode  sortMode;


#pragma mark -
#pragma mark Editing colum data
/** @name Editing colum data */

/** Dictates if the cells in this column are editable. `YES` results in cells that are able to respond to edit events, otherwise the cells appearing in this column are not editable.
 
 Note that implementing the delegate method shinobiDataGrid:shouldBeginEditingAutoCell: overrides this property.
*/
@property (nonatomic, assign) BOOL editable;



@end
