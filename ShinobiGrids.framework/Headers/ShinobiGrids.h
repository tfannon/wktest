#import <Foundation/Foundation.h>
#import "ShinobiGrid.h"
#import "ShinobiDataGrid.h"

/**
 A utility class which allows you to set licenseKeys for all the
 ShinobiGrids in your app, rather than having to configure each independently.

 This is best done early on, before any grids are created.

 @sa GridsUserGuide
 */

@interface ShinobiGrids : NSObject

/** Set a licenseKey for all ShinobiGrids in your app.
 */
+ (void)setLicenseKey:(NSString *)key;

/** The licenseKey set for all ShinobiGrids in your app.
 */
+ (NSString *)licenseKey;

/** Returns a string describing the version of the Grids framework being used.
 
 This includes a version number, the type of framework (Standard, or Trial) and the date upon which the version was released.
 */
+ (NSString *) getInfo;

@end
