//
//  SDataGridRow.h
//  Dev
//
//  Created by Ryan Grey on 07/12/2012.
//
//

#import <Foundation/Foundation.h>

/** Represents a row within a ShinobiDataGrid.*/

@interface SDataGridRow : NSObject

/** The section that the represented row belongs to.*/
@property (nonatomic, assign, readonly) NSInteger sectionIndex;
/** The index of the represented row within section at sectionIndex.*/
@property (nonatomic, assign, readonly) NSInteger rowIndex;

/** Returns an SDataGridRow object that represents a row at {rowIndex, sectionIndex}.
 
 @param rowIndex The index of the row within the section that it belongs to.
 @param sectionIndex The index of the section that the row belongs to.*/
- (id) initWithRowIndex:(NSInteger) rowIndex withSectionindex:(NSInteger) sectionIndex;

/** Returns an autoreleased SDataGridRow object as per initWithRowIndex:withSectionIndex:.*/
+ (id) rowWithRowIndex:(NSInteger) rowIndex sectionIndex:(NSInteger) sectionIndex;

/** Convenience method that returns an SDataGridRow object with `rowIndex == 0` and `sectionIndex == 0`.
 
 @return SDataGridRow object representing row at {0, 0}.*/
+ (id) zeroRow;

/** Checks that the object passed is of type SDataGridRow and that its rowIndex and sectionIndex match that of this object.*/
- (BOOL) isEqual:(id)object;

@end
