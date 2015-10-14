//adding 'prefix ## EnumEntry' to below macro will generate equivalent enums for SGrid and SDataGrid

#define LINES_ON_TOP_ENUM(prefix) \
typedef enum {    \
    prefix ## LinesVerticalOnTop,    \
    prefix ## LinesHorizontalOnTop    \
} prefix ## LinesOnTop

