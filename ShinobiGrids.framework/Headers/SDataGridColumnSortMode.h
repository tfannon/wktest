//
//  SDataGridColumnSortMode.h
//  ShinobiGrids
//
//
//

/** The sort mode of a SDataGridColumn.
 
 - SDataGridColumnSortModeNone: The column will not sort.
 - SDataGridColumnSortModeBiState: The column will sort in two orders, ascending and descending.
 - SDataGridColumNSortModeTriState: The column will sort in three orders, none, ascending, and descending.
 */
typedef enum {
    SDataGridColumnSortModeNone,
    SDataGridColumnSortModeBiState,
    SDataGridColumnSortModeTriState
} SDataGridColumnSortMode;
