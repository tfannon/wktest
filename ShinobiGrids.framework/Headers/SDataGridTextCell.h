//
//  SDataGridTextCell.h
//  Dev
//
//  Created by Ryan Grey on 29/11/2012.
//
//

#import "SDataGridTextInputCell.h"

/** This provides an easy mechanism for populating your cells with single-line text content. An object of this class has a textField property for convenience. Set the text of this property (`[textField setText:stringObject]`) to quickly generate content for an object of this class. Objects of this class are editable by the user - see the singleTapEventMask and doubleTapEventMask property of SDataGrid to customise this.*/
@interface SDataGridTextCell : SDataGridTextInputCell

/** The text field responsible for rendering single-line text content in this cell.*/
@property (nonatomic, retain, readonly) UITextField *textField;

@end
