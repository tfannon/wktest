//
//  SDataGridColumnSortMode.h
//  ShinobiGrids
//
//
//

/** The current sort order of a column.
 
 - SDataGridColumnSortOrderNone: The column is unsorted.
 - SDataGridColumnSortOrderAscending: The column is sorted from smallest to largest.
 - SDataGridColumnSortOrderDescending: The column is sorted from largest to smallest.
 */
typedef enum {
    SDataGridColumnSortOrderNone,
    SDataGridColumnSortOrderAscending,
    SDataGridColumnSortOrderDescending
} SDataGridColumnSortOrder;
