// SGridRowStruct.h

#import <Foundation/Foundation.h>

typedef struct {
    NSInteger index;
    NSInteger section;
} SGridRow;

/** @name SGridRow convenience methods*/

/** This method allows for the easy construction of a SGridRow struct.
 
 @param rowIndex The index of the row within the section.
 @param sectionIndex The index of the section within the grid.
 
 @return The SGridRow struct that represents a row at `rowIndex` of `sectionIndex` within the grid.*/
SGridRow SGridRowMake (NSInteger rowIndex, NSInteger sectionIndex);

/** This method allows for the easy construction of a SGridRow struct that represents the first row of the first section.*/
extern const SGridRow SGridRowZero;

NSString * NSStringFromSGridRow(SGridRow row);
BOOL SGridRowEqualsRow (SGridRow firstRow, SGridRow secondRow);
BOOL SGridRowLessThanRow (SGridRow firstRow, SGridRow secondRow);
BOOL SGridRowLessThanOrEqualToRow(SGridRow firstRow, SGridRow secondRow);
BOOL SGridRowGreaterThanRow (SGridRow firstRow, SGridRow secondRow);
BOOL SGridRowGreaterThanOrEqualToRow (SGridRow firstRow, SGridRow secondRow);


@interface NSValue (SGridRow)
- (SGridRow) SGridRowValue;
@end
