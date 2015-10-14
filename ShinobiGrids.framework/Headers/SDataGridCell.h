//
//  SDataGridCell.h
//  Dev
//
//  Created by Ryan Grey on 29/11/2012.
//
//

#import <UIKit/UIKit.h>
#import "SGridEventResponder.h"

@class SDataGridCoord;
@class SDataGridCellStyle;

/** An SDataGridCell object is used to represent a cell within a ShinobiDataGrid and can be located within the grid via its coordinate property. This class provides basic cell functionality such as cell selection (see SDataGridCell protocol). This class is ideal if you want to provide custom content that the SDataGridTextCell (and subclasses) are not suited for - as instances of this class have no automatic content, they are effective containers for other UIView objects (or descendants) that you may wish to add as subviews to the cell.*/

@interface SDataGridCell : UIView <SGridEventResponder>







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
@property (nonatomic, retain) SDataGridCellStyle *selectedStyle;

/** This method is called in order to style each cell as the grid is preparing
 to display.
 
 If you create your own cell subclass you may want to override this method to
 ensure that the style object is properly used in the styling of the cell. For
 example the SGridAutoCell implementation ensures that text alignment is properly
 applied to the cell
 */
- (void) applyStyle:(SDataGridCellStyle*) style;

/** This property uniquely identifies this cell within its parent grid.*/
@property (nonatomic, assign, readonly) SDataGridCoord *coordinate;

@end
