//
//  SDataGridDataSourceHelperDelegate.h
//  Dev
//
//  Created by Colin Eberhardt on 07/01/2013.
//
//

#import <Foundation/Foundation.h>
#import "SDataGridDelegate.h"

@class SDataGridDataSourceHelper;

/** The delegate of a SDataGridDataSourceHelper object must adopt the SDataGridDataSourceHelperDelegate protocol.
 */
@protocol SDataGridDataSourceHelperDelegate <SDataGridDelegate>

@optional

/** Informs the delegate that the selection state has changed.
 
 @param helper The dataSource-helper that is indicating a state change.
 @param selectedItems The items that are no selected. This is an NSArray of model objects.*/
- (void) dataGridDataSourceHelper:(SDataGridDataSourceHelper*)helper didUpdateSelectedItems:(NSArray*)selectedItems;


/** The SDataGridDataSourceHelper uses NSObject:valueForKey to determine the value for a given property for each data object. If you want to return a different value for the purposes of grouping, you can implement this method on your delegate, returning a different value for the property of interest. If you return `nil` for any propertyKey, the default behaviour using NSObject:valueForKey will be used in this case.
 
 @param helper The datasource helper that is making this request.
 @param propertyKey The name of the property that the datasource helper is requesting a value for.
 @param object The data object that the datasource helper is requesting a value from.
 @return the group value for the given property, or 'nil', to use the default behaviour.
 */
- (id) dataGridDataSourceHelper:(SDataGridDataSourceHelper*)helper groupValueForProperty:(NSString*)propertyKey withSourceObject:(id)object;

/** The SDataGridDataSourceHelper uses NSObject:valueForKey to determine the value for a given property for each data object. If you want to return a different value for the purposes of sorting, you can implement this method on your delegate, returning a different value for the property of interest. If you return `nil` for any propertyKey, the default behaviour using NSObject:valueForKey will be used in this case.
 
 @param helper The datasource helper that is making this request.
 @param propertyKey The name of the property that the datasource helper is requesting a value for.
 @param object The data object that the datasource helper is requesting a value from.
 @return the sort value for the given property, or 'nil', to use the default behaviour.*/
- (id) dataGridDataSourceHelper:(SDataGridDataSourceHelper*)helper sortValueForProperty:(NSString*)propertyKey withSourceObject:(id)object;

/** The SDataGridDataSourceHelper uses NSObject:valueForKey to determine the value for a given property for each data object. If you want to return a different value for the purposes of display, you can implement this method on your delegate, returning a different value for the property of interest. If you return `nil` for any propertyKey, the default behaviour using NSObject:valueForKey will be used in this case.
 
 @param helper The datasource helper that is making this request.
 @param propertyKey The name of the property that the datasource helper is requesting a value for.
 @param object The data object that the datasource helper is requesting a value from.
 @return the display value for the given property, or 'nil', to use the default behaviour.*/
- (id) dataGridDataSourceHelper:(SDataGridDataSourceHelper*)helper displayValueForProperty:(NSString*)propertyKey withSourceObject:(id)object;

/** The SDataGridDataSourceHelper is able to automatically populate columns that contain SDataGridTextCell instances. For any other cell type you must implement this delegate method in order to populate the cell. The cell that should be populated is passed via the 'cell' parameter, and the value that it should be populated is passed via the 'value' parameter.
 
 If you return NO for a propertyKey, the default behaviour of the datasource helper will used. This allows you to selectively populate cells.
 
 @param helper The datasource helper that is making this request.
 @param cell The cell to be populated.
 @param value The value to populate the cell with, this is the value that the datasource helper has already extracted from the source object.
 @param propertyKey The name of the property that this cell should be populated with.
 @param object The data object that is being rendered in the row that this cell belongs to.
 @return 'YES' to indicate that cell has been populated for the given propertyKey, or 'NO' to indicate that the cell has not been populated by this method and that the datasource helper should populate the cell using the deafult behaviour.*/
- (BOOL) dataGridDataSourceHelper:(SDataGridDataSourceHelper*)helper populateCell:(SDataGridCell*)cell withValue:(id)value forProperty:(NSString*)propertyKey sourceObject:(id)object;

@end
