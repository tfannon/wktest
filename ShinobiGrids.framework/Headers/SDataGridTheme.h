#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface UIColor (hex)
+ (id) colorWithHex:(unsigned)hex alpha:(CGFloat)alpha;
@end

@class SDataGridCellStyle;
@class SDataGridSectionHeaderStyle;
@class SDataGridLineStyle;


/**
 A data-grid theme can set the initial styling properties of a data-grid for
 you to further customize if you wish. The data-grid comes with four preset
 themes and any data-grid that is rendered will ask the theme for the current
 set of colors and styles.

 The four themes are:

   + iOS - Fits in nicely with the Apple styled UIKit controls
   + iOS 7 - Fits in nicely with the 'flat' Apple styled iOS 7 UIKit controls
   + Light - Lighter and more neutral colors with subtle highlighting
   + Dark - Darker colors with bright highlighting

   The default theme is iOS theme for iOS 6 and older devices, and iOS 7 for
   iOS 7 and newer. To change the theme that a data-grid is using, you can use
   the `-[ShinobiDataGrid applyTheme:]` method.  You can create particular
   themes by using the SDataGridTheme subclasses,
   `SDataGridiOSTheme`, `SDataGridiOS7Theme`, `SDataGridLightTheme` and
   `SDataGridDarkTheme`.

   `[myGrid applyTheme:[SDataGridDarkTheme new]];`

 */

@interface SDataGridTheme : NSObject

typedef NS_ENUM(NSInteger, SDataGridInitialTheme)
{
    SDataGridInitialThemeiOS,
    SDataGridInitialThemeLight,
    SDataGridInitialThemeDark,
    SDataGridInitialThemeiOS7
};

#define SDataGridInitialThemeCOUNT 4


#pragma mark -
#pragma mark Changing themes
/** @name Changing themes */

/** Sets the theme styling that all new data-grids will be created with.

Only applies to data-grids that are created after this is set.

 <code> typedef enum
 {
 SDataGridInitialThemeiOS,
 SDataGridInitialThemeLight,
 SDataGridInitialThemeDark,
 } SDataGridInitialTheme;
 </code>

Using `-[ShinobiDataGrid applyTheme:]` is now preferred over this static method
 */
+ (void) setInitialTheme:(SDataGridInitialTheme)initial;

/** Get the theme styling that all new data-grids will be created with.
 */
+ (SDataGridInitialTheme)initialTheme;

#pragma mark -
#pragma mark Current initial-theme colors
/** @name Current initial-theme colors */

/** A UIColor representing the background color set for cells in this theme.
 
 Note: alternate row styling may be configured see initialThemeCellBackgroundColorAlternate
 */
+ (UIColor *) initialThemeCellBackgroundColor;

/** A UIColor representing the background color set for cells in this theme.
 
 Note: this is the alternate color, see also initialThemeCellBackgroundColor
 */
+ (UIColor *) initialThemeCellBackgroundColorAlternate;

/** A UIColor representing the background color set for selected cells in this theme. */
+ (UIColor *) initialThemeCellSelectionColor;

/** A UIColor representing the background color set for header cells in this theme.
 
 Note: header cells are defined per SDataGridColumn
 */
+ (UIColor *) initialThemeHeaderCellColor;

/** A UIColor representing the fill color set for section headers in this theme.
 */
+ (UIColor *) initialThemeSectionHeaderBackgroundColor;

/** A UIColor representing the font color set for section headers in this theme.
 */
+ (UIColor *) initialThemeSectionHeaderFontColor;

#pragma mark -
#pragma mark Current initial-theme styles
/** @name Current initial-theme styles */

/** The default style applied to rows when this theme is set initially
 
Note: alternate row styling may be configured see defaultAlternateRowStyle */
+ (SDataGridCellStyle *) defaultRowStyle;

/** The default style applied to rows when this theme is set initially
 
 Note: this is the alternate row styling, see also defaultRowStyle
 
 @warning *Important:* This property has been deprecated in preference of `defaultAlternateRowStyle`. */
 
 
+ (SDataGridCellStyle *) defaultAlternatingRowStyle __attribute__((deprecated("Use `defaultAlternateRowStyle` instead")));

/** The default style applied to rows when this theme is set initially
 
 Note: this is the alternate row styling, see also defaultRowStyle */
+ (SDataGridCellStyle *) defaultAlternateRowStyle;

/** The default style applied to selected cells when this theme is set initially
 */
+ (SDataGridCellStyle *) defaultSelectedCellStyle;

/** The default style applied to cells in the header row */
+ (SDataGridCellStyle *) defaultHeaderRowStyle;

/** The default style applied to the section header */
+ (SDataGridSectionHeaderStyle *) defaultSectionHeaderStyle;

/** The default style applied to grid lines */
+ (SDataGridLineStyle *) defaultGridLineStyle;

#pragma mark - Instance Theming Methods

/** The default style applied to rows when this theme is set initially

Note: alternate row styling may be configured see alternateRowStyle */
@property(nonatomic, retain) SDataGridCellStyle *rowStyle;

/** The default style applied to rows when this theme is set initially

 Note: this is the alternate row styling, see also rowStyle */
@property(nonatomic, retain) SDataGridCellStyle *alternateRowStyle;

/** The default style applied to selected cells when this theme is set initially
 */
@property(nonatomic, retain) SDataGridCellStyle *selectedCellStyle;

/** The default style applied to cells in the header row */
@property(nonatomic, retain) SDataGridCellStyle *headerRowStyle;

/** The default style applied to grid lines */
@property(nonatomic, retain) SDataGridLineStyle *gridLineStyle;

/** The default style applied to the section header */
@property(nonatomic, retain) SDataGridSectionHeaderStyle *sectionHeaderStyle;

/** A UIColor representing the tint color while the grid is reordering, in this theme. */
@property(nonatomic, assign) UIColor *tintColor;

/** A BOOL controlling whether iOS 7 arrows are used in this theme. */
@property(nonatomic, assign) BOOL iOS7Arrows;

/** A BOOL controlling whether vertical grid lines are hidden in this theme. */
@property(nonatomic, assign) BOOL hideVerticalGridlines;

@end

/** A subclass of SDataGridTheme with properties setup for an iOS 6 style.
 Pass an instance of this class to a DataGrid's applyTheme method to style your grid.
 */
@interface SDataGridiOSTheme : SDataGridTheme
@end

/** A subclass of SDataGridTheme with properties setup for an iOS 7 style.
 Pass an instance of this class to a DataGrid's applyTheme method to style your grid.
 */
@interface SDataGridiOS7Theme : SDataGridTheme
@end

/** A subclass of SDataGridTheme with properties setup for a light style.
 Pass an instance of this class to a DataGrid's applyTheme method to style your grid.
 */
@interface SDataGridLightTheme : SDataGridTheme
@end

/** A subclass of SDataGridTheme with properties setup for a dark style.
 Pass an instance of this class to a DataGrid's applyTheme method to style your grid.
 */
@interface SDataGridDarkTheme : SDataGridTheme
@end
