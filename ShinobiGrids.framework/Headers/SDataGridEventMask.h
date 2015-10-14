//adding 'prefix ## BitMaskEntry' to below macro will generate equivalent bitmask entries for SGrid and SDataGrid
typedef enum { SDataGridEventNone = 0, SDataGridEventSelect = 1 << 0, SDataGridEventEdit = 1 << 1, } SDataGridEvent;
