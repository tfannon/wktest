// SGridCell.h
#import <UIKit/UIKit.h>
#import "SGridEventResponder.h"

@class SGridCoordMutable;
@class SGridLayer;
@class SGridCellStyle;
@class ShinobiGrid;
@class SGridCoord;

/** An SGridCell object is used to represent a cell within a ShinobiGrid and can be located within the grid via its gridCoord property. This class provides basic cell functionality such as cell selection (see SGridCell protocol). This class is ideal if you want to provide custom content that the SGridAutoCell (and subclasses) are not suited for - as instances of this class have no automatic content, they are effective containers for other UIView objects (or descendants) that you may wish to add as subviews to the cell. SGridCell's use the reuseIdentifier property for performance reasons much in the same manner as the Cocoa framework's `UIScrollView` and `UITableViewCell` classes. For this reason it is important to ensure you make effective use of the reuseIdentifier for each different type of cell content you wish to display in the ShinobiGrid - see the included project samples for examples of the reuseIdentifer in use.*/

@interface SGridCell:UIView <NSCopying, SGridEventResponder>








/** @name Initialization */

/** Initializes a cell with a reuse identifier and returns it to the caller.
 @warning *Important* This method must be used to initialize a cell - using
 `init` or `initWithFrame` is not permitted.
 
 When subclassing a cell for use in a ShinobiDataGrid, ensure that you have
 overridden this constructor, as this is the method which the DataGrid will
 call when instantiating cells.
 
 */
- (id) initWithReuseIdentifier:(NSString *) identifier;


/** @name Layout */

/** Setting this property to `YES` results in any added subviews having
 dimensions automatically applied so that they are the same size as the cell.
 Default value is `YES` for the grid and `NO` for the data-grid.
 */
@property (nonatomic, assign) BOOL fitSubviewsToView;

/**
* Returns the available frame for this cell's content.
*
* This is typically calculated by taking the frame of this cell, applying all
* required insets and then applying any other borders or constraints.
*
* The resulting frame can be used to safely position any content within the cell
* without overlapping any insets or borders.
*/
@property (nonatomic, readonly) CGRect contentFrame;

/** The amount of space indented around the content of the cell. For example, the textField on an SGridAutoCell.

Subclasses of this class must decide how to adhere to this inset. Calling contentFrame: is a good way to get the available frame, adhering to these insets, for any content to be positioned in this cell.

@return A UIEdgeInsets representing the indent for every edge surrounding the textField.*/
@property (nonatomic) UIEdgeInsets contentInset;




/** @name Selection */


/** A boolean that indicates if this cell is selected or not.
 
 @return selected `YES` if this cell is selected. `NO` otherwise.
 */
@property (nonatomic, assign, readonly) BOOL selected;

/** Set this cell as being selected or deselected.
 
 @warning *Important* Note that programmatic cell selection ignores the grid's
 `selectionMode`, meaning that there will be no automatic deselection in any
 circumstances.
 
 @parameter isSelected `YES` if the cell should be set as selected.
 @parameter animated `YES` if this cell's selection change should be animated.
 */
- (void) setSelected:(BOOL)isSelected animated:(BOOL)animated;





/** @name Subclassing an SGridCell.
 
 It is unlikely that you will ever call these methods directly. However you may
 wish to override these methods to tailor the behaviour of SGridCell subclasses.
 */

/** This method is called before a cell is returned from the pool that it has
 been stored in. Any state that may need to be reset prior to it being retrieved
 from -[ShinobiGrid dequeueReusableCellWithIdentifier:] can be done inside this
 method.
 
 @warning *Important* This method is a potential performance hotspot as it is
 called every time a cell is retrieved as a result of a call to the data source
 method. For this reason you should only override this method to reset a property
 of this cell if changing said property within the datasource method is not
 applicable.
 */
- (void) resetForReuse;

/** The style that will be applied to the cell when selected.
 */
@property (nonatomic, retain) SGridCellStyle *selectedStyle;

/** This method is called in order to style each cell as the grid is preparing
 to display.
 
 If you create your own cell subclass you may want to override this method to
 ensure that the style object is properly used in the styling of the cell. For
 example the SGridAutoCell implementation ensures that text alignment is properly
 applied to the cell
 */
- (void) applyStyle:(SGridCellStyle*) style;





/** A string used to identify a cell that is reusable. (read-only)
 
 The reuse identifier is associated with a SGridCell object that the ShinobiGrid's data source creates with the intent to reuse it as the basis (for performance reasons) for multiple cells of a ShinobiGrid object. It is assigned to the cell object in initWithReuseIdentifier: and cannot be changed thereafter. A ShinobiGrid object maintains a collection of the currently reusable cells, each with its own reuse identifier, and makes them available to the data source in the dequeueReusableCellWithIdentifier: method.*/
@property (nonatomic, readonly) NSString *reuseIdentifier;



/** The color that the cell will change to when selected.
 
 Seting this property to `nil` will result in a selection color that is identical to the cell's final background color.
 
 @warning *Important* Deprecated for versions after 1.1.2. Use selectedStyle (inherited from the SGridCell protocol) instead.*/
@property (nonatomic, retain) UIColor *selectedColor __attribute__((deprecated ("Use selectedStyle (inherited from the SGridCell protocol) instead")));



/** @name Cell Location */
/** This property represents the coordinates of the cell and uniquely identifies it within its parent grid.
 
 The notation {`colIndex`, `row`}, is sometimes used to refer to a gridCoord object within this documentation.*/
@property (nonatomic, retain, readonly) SGridCoord *gridCoord;


@end
