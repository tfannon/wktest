//
//  SGridTextLabelDelegate.h
//  Dev
//
//  Created by Ryan Grey on 18/02/2013.
//
//

#import <Foundation/Foundation.h>
@class SGridTextView;

@protocol SGridTextViewDelegate <NSObject>

@required

- (void) didFinishLayingOutSGridTextView:(SGridTextView*) sGridTextView;

@end
