//adding 'prefix ## EnumEntry' to below macro will generate equivalent enums for SGrid and SDataGrid
typedef enum { SDataGridDragDirectionNone = 0, SDataGridDragDirectionCol = 1 << 0, SDataGridDragDirectionRow = 1 << 1, SDataGridDragDirectionBoth = SDataGridDragDirectionCol | SDataGridDragDirectionRow } SDataGridDragDirection;
