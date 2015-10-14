//adding 'prefix ## BitMaskEntry' to below macro will generate equivalent bitmask entries for SGrid and SDataGrid
typedef enum { SGridEventNone = 0, SGridEventSelect = 1 << 0, SGridEventEdit = 1 << 1, } SGridEvent;
