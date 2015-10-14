//adding 'prefix ## EnumEntry' to below macro will generate equivalent enums for SGrid and SDataGrid

#define SELECTION_MODE_ENUM(prefix) \
typedef enum {    \
prefix ## SelectionModeCellSingle,    \
prefix ## SelectionModeCellMulti,   \
prefix ## SelectionModeRowSingle,   \
prefix ## SelectionModeRowMulti,   \
prefix ## SelectionModeNone    \
} prefix ## SelectionMode
