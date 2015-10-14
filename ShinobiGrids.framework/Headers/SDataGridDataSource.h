#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class ShinobiDataGrid;
@class SDataGridCell;
@class SDataGridCoord;

/** The SDataGridDataSource protocol is adopted by an object that mediates the application's data model for a ShinobiDataGrid object. The datasource is responsible for providing the necessary information to construct a ShinobiDataGrid object - such as the number of rows/sections and for populating cells for each coordinate in the grid.
 
 Information relating to the style and appearance of the ShinobiDataGrid is provided by the object that conforms to the SDataGridDelegate protocol. In this manner, the data model and appearance of the grid are kept separate.
 
 ShinobiDataGrid uses cell pooling to make your grid as memory efficient as possible. Cells that are not currently visible are returned to an internal cell pool for later use and cells that become visible due to users scrolling/panning are retrieved from this pool. This means that ShinobiDataGrid caches cells only for visible rows and columns, but caches styling objects for the entire grid. For this reason, an appropriate cell object is handed to the -shinobiDataGrid:prepareCellForDisplay: method and is the primary method for populating cells. 
 
 
*/ 

@protocol SDataGridDataSource <NSObject>

#pragma mark -
#pragma mark Configuring a ShinobiDataGrid

@required

/** @name Configuring a ShinobiDataGrid*/
/** This is the primary datasource method that gives you the opportunity to apply data/content to a cell prior to its appearance in the grid.
 
 @warning *Important* The grid recycles cells for performance reasons. This means that any cell provided to you by this method may have already been used within the grid. It is therefore important to set all content on the cell for its given position (-[SDataGridCell coord]) so that no artefacts from prior use are present when displayed.*/
- (void)shinobiDataGrid:(ShinobiDataGrid *)grid prepareCellForDisplay:(SDataGridCell*) cell;

/** Asks the data source to return the number of rows that the a particular section within the ShinobiDataGrid object should have.
 
 @param grid The grid that contains the section that is requesting the information.
 @param sectionIndex The index of the section that will have the number of rows returned.
 
 @return The number of rows that the specified section will have within the grid.*/
- (NSUInteger)shinobiDataGrid:(ShinobiDataGrid *) grid numberOfRowsInSection:(NSInteger) sectionIndex;

@optional

/** Asks the data source to return the number of sections that the ShinobiDataGrid object should have.
 
 This data source method is optional - if this method is not implemented the grid will have 1 section by default.
 
 @warning *Important* If 1 is returned in this method you MUST implement the SDataGridDelegate method 'shinobiDataGrid:styleForSectionHeaderAtIndex:' for that section to be displayed. The SDataGridDelegate method returns the SDataGridSectionHeaderStyle to be applied to your grid's only section header. If this method is not implemented your section header WILL NOT be displayed.
 
 @param grid The grid that is requesting this information.
 
 @return The number of sections that `grid` will have.*/
- (NSUInteger) numberOfSectionsInShinobiDataGrid:(ShinobiDataGrid *) grid;

#pragma mark -
#pragma mark Customizing Section Headers
/** @name Customizing Section Headers*/
/** Asks the data source for the title of the movable portion of header of the specified section of the ShinobiDataGrid object.
 If you do not implement this method, a default title such as "Section 1" will be used. Returning nil will result in the specified section having a blank header.
 @warning *Important* Implementing shinobiGrid:viewForHeaderInSection:inFrame: overrides this method
 */
- (NSString *)shinobiDataGrid:(ShinobiDataGrid *)grid titleForHeaderInSection:(NSInteger)section;

/** Asks the data source for the title of the frozen portion of the header of the specified section of the ShinobiDataGrid object.
 If you do not implement this method a default title will be used. Returning nil will result in the specified section having a blank frozen header.
 @warning *Important* Implementing shinobiGrid:viewForFrozenHeaderInSection:inFrame: overrides this method
 */
- (NSString *)shinobiDataGrid:(ShinobiDataGrid *)grid titleForFrozenHeaderInSection:(NSInteger)section;

/** Asks the data source for a view for the movable portion of header of the specified section of the ShinobiDataGrid object.
 If you do not implement this method, the shinobiGrid:titleForHeaderInSection: delegate method is used as a fallback.
 Returning nil will also cause the title method to be used.
 The frame parameter specifies the header's bounds, which you can use to size your view appropriately
 */
- (UIView *)shinobiDataGrid:(ShinobiDataGrid *)grid viewForHeaderInSection:(NSInteger)section inFrame:(CGRect)frame;

/** Asks the data source for a view for the frozen portion of header of the specified section of the ShinobiDataGrid object.
 If you do not implement this method, the shinobiGrid:titleForFrozenHeaderInSection: delegate method is used as a fallback.
 Returning nil will also cause the title method to be used.
 The frame parameter specifies the header's bounds, which you can use to size your view appropriately.
 */
- (UIView *)shinobiDataGrid:(ShinobiDataGrid *)grid viewForFrozenHeaderInSection:(NSInteger)section inFrame:(CGRect)frame;



@end
