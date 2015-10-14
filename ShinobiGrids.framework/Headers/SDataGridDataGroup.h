//
//  SDataGroup.h
//  Dev
//
//  Created by Colin Eberhardt on 09/01/2013.
//
//

#import <Foundation/Foundation.h>

/** The SDataGridDataGroup is a container for a collection of items that have been grouped together by the SDataGridDataSourceHelper. 
 */
@interface SDataGridDataGroup : NSObject

/** The common value across this group. */
@property (nonatomic, retain) NSObject* groupValue;

/** The items that occupy this group. */
@property (nonatomic, retain) NSArray* items;

- (id) initWithGroupValue:(NSObject*)value items:(NSArray*)items;

@end
