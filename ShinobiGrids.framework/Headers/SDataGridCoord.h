//
//  SDataGridCoord.h
//  Dev
//
//  Created by Ryan Grey on 04/10/2012.
//
//

#import <Foundation/Foundation.h>

/** An object of this type represents the position of a given cell object within the parent grid, located by row and column.*/

@class SDataGridRow;
@class SDataGridColumn;

@interface SDataGridCoord : NSObject {
}

/** Initializes a coordinate object using column and row.*/
- (id) initWithCol:(SDataGridColumn *)column row:(SDataGridRow *)row;

/** Returns an autoreleased coordinate object using initWithCol:row:.*/
+ (id) coordinateWithCol:(SDataGridColumn *)column row:(SDataGridRow *)row;

/** The row that this coordinate belongs to.*/
@property(nonatomic, retain, readonly) SDataGridRow    *row;

/** The column that this coordinate belongs to.*/
@property(nonatomic, retain, readonly) SDataGridColumn *column;

@end
