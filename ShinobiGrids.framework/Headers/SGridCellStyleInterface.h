#pragma mark -
#pragma mark Initializing
/**@name Initializing*/

/** Returns a style object that represents the passed parameters. Passing nil to any parameter results in a default value being used.*/
- (id) initWithBackgroundColor:(UIColor*) backgroundColor withTextColor:(UIColor*)textColor withTextAlignment:(NSTextAlignment)textAlignment withVerticalTextAlignment:(UIControlContentVerticalAlignment)textVerticalAlignment withFont:(UIFont*)font;

/** Returns an autoreleased style object using the corresponding `initWith...` method.*/
+ (id) styleWithBackgroundColor:(UIColor*) backgroundColor withTextColor:(UIColor*)textColor withTextAlignment:(NSTextAlignment)textAlignment withVerticalTextAlignment:(UIControlContentVerticalAlignment)textVerticalAlignment withFont:(UIFont*)font;

/** Returns a style object that represents the passed parameters. Passing nil to any parameter results in a default value being used.*/
- (id) initWithBackgroundColor:(UIColor*) backgroundColor withTextColor:(UIColor*)textColor withFont:(UIFont*)font;

/** Returns an autoreleased style object using the corresponding `initWith...` method.*/
+ (id) styleWithBackgroundColor:(UIColor*) backgroundColor withTextColor:(UIColor*)textColor withFont:(UIFont*)font;

#pragma mark -
#pragma mark Style Properties
/** @name Style Properties*/

/** The color that will be used for the background of the cell.*/
@property (nonatomic, retain) UIColor *backgroundColor;
/** The color that will be used for the text of the cell.
 
 If the cell has no text then this property is ignored.*/
@property (nonatomic, retain) UIColor *textColor;
/** The horizontal alignment that will be used for the text of the cell.
 
 If the cell has no text then this property is ignored.*/
@property (nonatomic, assign) NSTextAlignment textAlignment;
/** The font that will be used for the text of the cell.
 
 If the cell has no text then this property is ignored.*/
@property (nonatomic, retain) UIFont  *font;

/** The vertical alignment that will be applied to any text within the cell.
 
 If the cell has no text then this property is ignored.*/
@property (nonatomic, assign) UIControlContentVerticalAlignment textVerticalAlignment;

/** The gradient that will be applied to the cell
 */
@property (nonatomic, retain) GRADIENT_TYPE *gradient;

/** The indents that pad the inside of the cell
 */
@property (nonatomic) UIEdgeInsets contentInset;
