//
//  UITextView+SPUImage.h
//  ShinobiPlayUtils
//
//  Created by Alison Clarke on 23/03/2015.
//
//  Copyright 2015 Scott Logic
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPUTextViewImageAlignment) {
  SPUTextViewImageAlignmentLeft,
  SPUTextViewImageAlignmentRight
};

@interface UITextView (SPUImage)

/*
 Add the given image to the text view with an exclusion path so the text wraps around it.
 */
- (void)addImage:(UIImage *)image imageSize:(CGSize)size imageAlignment:(SPUTextViewImageAlignment)imageAlignment
       yPosition:(CGFloat)yPosition padding:(CGFloat)padding;

@end
