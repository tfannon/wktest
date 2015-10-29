//
//  UITextView+SPUImage.m
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

#import "UITextView+SPUImage.h"

@implementation UITextView (SPUImage)

- (void)addImage:(UIImage *)image imageSize:(CGSize)size imageAlignment:(SPUTextViewImageAlignment)imageAlignment
       yPosition:(CGFloat)yPosition padding:(CGFloat)padding {
  
  CGFloat xPosition = (imageAlignment == SPUTextViewImageAlignmentLeft)
                          ? padding + self.textContainer.lineFragmentPadding
                          : CGRectGetWidth(self.frame) - size.width - padding - self.textContainer.lineFragmentPadding;
  
  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
  [imageView setFrame:CGRectMake(xPosition, yPosition + padding, size.width, size.height)];
  
  // We need to add an exclusion path to the text view so the text will wrap around the image.
  // The coordinates of the exclusion path need to be specified in container coordinates like so
  CGRect imageFrame = [self convertRect:imageView.bounds fromView:imageView];
  imageFrame.origin.x -= self.textContainerInset.left;
  imageFrame.origin.y -= self.textContainerInset.top;
  
  UIBezierPath *exclusionPath;
  if (imageAlignment == SPUTextViewImageAlignmentLeft) {
    exclusionPath = [UIBezierPath bezierPathWithRect:CGRectMake(0,
                                                                CGRectGetMinY(imageFrame),
                                                                CGRectGetMaxX(imageFrame) + padding,
                                                                CGRectGetHeight(imageFrame))];
    
  } else {
    exclusionPath = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMinX(imageFrame) - padding,
                                                                CGRectGetMinY(imageFrame),
                                                                CGRectGetWidth(imageFrame) + (padding * 2),
                                                                CGRectGetHeight(imageFrame))];
  }
  self.textContainer.exclusionPaths = @[exclusionPath];
  [self addSubview:imageView];
}


@end
