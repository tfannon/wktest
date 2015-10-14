/** The text label responsible for rendering multi-line text content in this cell.
 
 *Important* When a multi line text cell goes into editing mode this UILabel is visually switched with a UITextView (editingTextView) to allow keyboard input. This textLabel is still an accessible property, but the UI presented within the cell is rendered via editingTextView.*/
@property (nonatomic, retain) UILabel *textLabel;

/** The text view that is temporarily used whilst the cell is editing. When the cell is not editing this property will return nil.*/
@property (nonatomic, retain, readonly) UITextView *editingTextView;
