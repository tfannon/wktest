//
//  SDataGridDataSourceHelper.h
//  Dev
//
//  Created by Colin Eberhardt on 07/01/2013.
//
//

#import <Foundation/Foundation.h>
#import "SDataGridDataSource.h"
#import "SDataGridDataSourceHelperDelegate.h"

/** The SDataGridDataSourceHelper is a utility class which makes it easier to render an NSArray of items within a ShinobiDataGrid. The datasource helper sets itself as both the delegate and datasource of the data-grid, automatically handling population of the data-grid cells, sorting, grouping (into sections) and row selection.
 
The datasource helper must be associated with a data-grid via the initWithDataGrid initializer. The data that the datasource helper renders in the associated data-grid is specified via the data property. The columns of the data-grid should be supplied in the usual fashion (via the addColumn method), however each column must have its propertyKey property set. The datasource helper uses the propertyKey associated with each column to extract the value that should be rendered in the column for each of the supplied objects, via NSObject:valueForKey.
 
The datasource helper exposes a delegate, which extends the SDataGridDelegate. Delegate method invocations from the data-grid are forwarded to the datasource helper delegate, allowing you to handle the delegate methods, such as row re-ordering, or sorting, within your code. The datasource helper delegate also provides methods that allow you to customise the value used for grouping, sorting, or rendering the property of an object. This can be used to customise how sorting or grouping is applied, or provide extra formatting details for a property.
 
The datasource helper is able to automatically populate SDataGridTextCell columns, the value extracted for the column (as defined by the column's propertyKey value), is converted to a string via the `%@` formatter, with the SDataGridTextCell textField being set accordingly. For other cell types you will need to implement the delegate dataGridDataSourceHelper:populateCell:withValue:forProperty:sourceObject: method in order to populate the cell with the value provided by the datasource helper.
 */
@interface SDataGridDataSourceHelper : NSObject <SDataGridDataSource, SDataGridDelegate>

/** The data which will be rendered by the grid */
@property (nonatomic, retain) NSArray* data;

/** The SDataGrid that this helper is associated with */
@property (readonly, nonatomic) ShinobiDataGrid* dataGrid;

/** The model objects that have been selected in the grid. */
@property (nonatomic, retain) NSArray* selectedItems;

/** The property of the rendered items which is used to group the data */
@property (nonatomic, retain) NSString* groupedPropertyKey;

/** The property of the rendered items which is used to group the data */
@property (nonatomic) SDataGridColumnSortOrder groupedPropertySortOrder;

/** The object that acts as a delegate for the data-grid helper.  */
@property (nonatomic, assign) id<SDataGridDataSourceHelperDelegate> delegate;

/** The data in the order that it is currently being rendered by the grid. This property respects the current sort order and any row re-ordering applied by the user. 
 
    If the data has been grouped by setting the groupedPropertyKey of the datasource helper, the returned array will contain instances of SDataGridDataGroup, one per group. */
@property (readonly, nonatomic) NSArray* sortedData;

/** Initializes and returns a newly allocated datasource helper object.
 
 The new datasource helper is associated with the given ShinobiDataGrid and will set itself as both the datasource and delegate.
 
 @param dataGrid The grid that contains the section that is requesting the information.
 
 @return an initialized datasource helper object.
 */
- (id) initWithDataGrid:(ShinobiDataGrid*)dataGrid;

/** If you make changes to the underlying data (e.g. adding, removing or updating items), you should call this method to inform the datasource helper. When invoked the datasource helper will refresh the data-grid, whilst maintaining the sort, selection and group state. 
 */
- (void) reloadData;

@end
