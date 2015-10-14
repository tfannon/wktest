//adding 'prefix ## EnumEntry' to below macro will generate equivalent enums for SGrid and SDataGrid

#define ARROW_ORIENTATION_ENUM(prefix) \
typedef enum {    \
prefix ## ArrowOrientationUp,    \
prefix ## ArrowOrientationDown,    \
prefix ## ArrowOrientationLeft,     \
prefix ## ArrowOrientationRight     \
} prefix ## ArrowOrientation
