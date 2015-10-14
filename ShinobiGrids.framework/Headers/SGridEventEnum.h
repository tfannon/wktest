//adding 'prefix ## BitMaskEntry' to below macro will generate equivalent bitmask entries for SGrid and SDataGrid

#define EVENT_MASK(prefix) \
typedef enum {    \
prefix ## EventNone = 0,    \
prefix ## EventSelect = 1 << 0,    \
prefix ## EventEdit   = 1 << 1,    \
} prefix ## Event
