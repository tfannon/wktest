//adding 'prefix ## EnumEntry' to below macro will generate equivalent enums for SGrid and SDataGrid
typedef enum { SGridDragDirectionNone = 0, SGridDragDirectionCol = 1 << 0, SGridDragDirectionRow = 1 << 1, SGridDragDirectionBoth = SGridDragDirectionCol | SGridDragDirectionRow } SGridDragDirection;
