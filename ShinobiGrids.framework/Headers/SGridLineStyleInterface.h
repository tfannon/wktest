//Note that we need to use 'include' rather than 'import' so that the header file is actually included in both required files

#pragma mark - Creation
/**
 @name Creation
 */

/** Creates and returns an object which represents the style of a gridline with
 default properties.
 
 Default values are a width of `3.f` and a black color.
 */
+ (id)style;

/** Creates and returns an object which represents the style of a gridline with
 the supplied properties
 
 @param width The width in points of the gridline
 @param color The color of the gridline
 */
+ (id)styleWithWidth:(CGFloat)width withColor:(UIColor *)color;

#pragma mark - Initialization
/**
 @name Initialization
 */

/** Initializes a newly allocated object that represents the style of a gridline
 with default values.
 
 Default values are a width of `3.f` and a black color.
 */
- (id) init;

/** Initializes a newly allocated object that represents the style of a gridline
 with the supplied properties.
 
 @param width The width in points of the gridline
 @param color The color of the gridline
 */
- (id) initWithWidth:(CGFloat)width withColor:(UIColor *)color;

#pragma mark - Styling
/**
 @name Styling
 */

/**
 The width in points of the gridline that has this style applied to it.
 The minimum width that can be displayed is 1.0f
 */
@property (nonatomic, assign) CGFloat    width;

/**
 The color of the gridline that has this style applied to it.
 */
@property (nonatomic, retain) UIColor *color;
