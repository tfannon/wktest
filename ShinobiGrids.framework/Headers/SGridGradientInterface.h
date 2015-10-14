/** Create an autoreleased gradient with the given color and location arrays.

 @warning *Important* The number of colors must match the number of locations.
 */
+ (id) gradientWithColors:(NSArray *)colors
                locations:(NSArray *)locations;

/** Create a gradient with the given color and location arrays.
*/
- (id) initWithColors:(NSArray *)colors
            locations:(NSArray *)locations;

/** A readonly array of CGColorRef objects defining the color of each gradient
 stop. */
@property(nonatomic, retain, readonly) NSArray *colors;

/** A readonly array of NSNumber objects defining the location of each gradient
 stop as a value in the range [0, 1]. The values must be monotonically
 increasing. If a nil array is given, the stops are assumed to spread uniformly
 across the [0,1] range. */
@property(nonatomic, retain, readonly) NSArray *locations;
