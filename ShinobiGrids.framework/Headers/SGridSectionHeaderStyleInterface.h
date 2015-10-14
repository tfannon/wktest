/** @name Initializing a header style object.*/
/** Initialises a header style object with default values.*/
- (id) init;
/** Initialises a header style with the specified parameters.*/
- (id) initWithHeight:(CGFloat) height withBackgroundColor:(UIColor *) backgroundColor;
/** Initialises a header style with the specified parameters.*/
- (id) initWithHeight:(CGFloat) height withBackgroundColor:(UIColor *) backgroundColor withHidden:(BOOL)isHidden;

/** @name Styling*/
/** This boolean property indicates whether the section header is to be shown or not.
 
 If set to `YES` then the section at sectionIndex will have no header. Default value is `NO`.*/
@property (nonatomic, assign) BOOL hidden;

/** This property represents the height that will be applied to the section header(s).*/
@property (nonatomic, assign) CGFloat height;
/** This property represents the background color that will be applied to the section header(s).*/
@property (nonatomic, retain) UIColor *backgroundColor;

/** This property represents the text color that will be applied to the section header(s). */
@property (nonatomic, retain) UIColor *textColor;

/** This property represents the font that will be applied to the section header(s).*/
@property (nonatomic, retain) UIFont *font;
