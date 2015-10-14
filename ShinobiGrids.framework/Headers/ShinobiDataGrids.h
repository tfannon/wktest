#import <Foundation/Foundation.h>
#import "ShinobiDataGrid.h"

@class SDataGridTheme;

/**
 A utility class which allows you to set themes and licenseKeys for all the
 ShinobiDataGrids in your app, rather than having to configure each
 independently.

 This is best done early on, before any grids are created.

 @sa GridsUserGuide
 */

@interface ShinobiDataGrids : NSObject

/** Set a licenseKey for all ShinobiDataGrids in your app.
 */
+ (void)setLicenseKey:(NSString *)key;

/** The licenseKey set for all ShinobiDataGrids in your app.
 */
+ (NSString *)licenseKey;

/** Set a theme for all ShinobiDataGrids in your app.
 */
+ (void)setTheme:(SDataGridTheme *)theme;

/** The theme set for all ShinobiDataGrids in your app.
 */
+ (SDataGridTheme *)theme;

/** Returns a string describing the version of the Grids framework being used.
 
 This includes a version number, the type of framework (Standard, or Trial) and the date upon which the version was released.
 */
+ (NSString *) getInfo;

@end
