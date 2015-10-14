//adding 'prefix ## EnumEntry' to below macro will generate equivalent enums for SGrid and SDataGrid

#define DRAG_DIRECTION_ENUM(prefix)                                                   \
typedef enum {                                                                        \
prefix ## DragDirectionNone = 0,                                                      \
prefix ## DragDirectionCol = 1 << 0,                                                  \
prefix ## DragDirectionRow = 1 << 1,                                                  \
prefix ## DragDirectionBoth = prefix ## DragDirectionCol | prefix ## DragDirectionRow \
} prefix ## DragDirection
