#import "SDataGridCell.h"

@interface SDataGridTextInputCell : SDataGridCell

/* An SDataGridTextInputCell is an abstract class that requires the following methods to be overridden. */



/**@name Text*/

/**
* This property is a convenience for getting and setting the text on this cell's text input view.
*
* The type of the text input view and how it is connected to this property is the responsibility of subclasses.
*/
@property (nonatomic, retain) NSString *text;

@end
