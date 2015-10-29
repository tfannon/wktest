//
//  UIColor+SPUColor.m
//  ShinobiPlayUtils
//
//  Created by Alison Clarke on 07/10/2014.
//
//  Copyright 2014 Scott Logic
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

#import "UIColor+SPUColor.h"

static NSArray *shinobiPlayColors;

@implementation UIColor (SPUColor)

+ (UIColor *)shinobiRedColor {
  return [UIColor colorWithRed:228.0/255 green:35.0/255 blue:18.0/255 alpha:1];
}

+ (UIColor *)shinobiChartsPurpleColor {
  return [UIColor colorWithRed:113.0/255 green:32.0/255 blue:123.0/255 alpha:1];
}

+ (UIColor *)shinobiToolkitGreenColor {
  return [UIColor colorWithRed:0.0/255 green:142.0/255 blue:156.0/255 alpha:1];
}

+ (UIColor *)shinobiFormsBlueColor {
  return [UIColor colorWithRed:0.0/255 green:104.0/255 blue:162.0/255 alpha:1];
}

+ (UIColor *)shinobiDarkGrayColor {
  return [UIColor colorWithRed:83.0/255 green:96.0/255 blue:107.0/255 alpha:1];
}

+ (UIColor *)shinobiPlayBlueColor {
  return [UIColor colorWithRed:1/255.f *.8 green:122/255.f *.8 blue:255/255.f *.8 alpha:1.f];
}

+ (UIColor *)shinobiPlayGreenColor {
  return [UIColor colorWithRed:76/255.f *.8 green:217/255.f *.8 blue:100/255.f *.8 alpha:1.f];
}

+ (UIColor *)shinobiPlayOrangeColor {
  return [UIColor colorWithRed:255/255.f *.9 green:149/255.f *.9 blue:1/255.f *.9 alpha:1.f];
}

+ (UIColor *)shinobiPlayRedColor {
  return [UIColor colorWithRed:255/255.f *.9 green:45/255.f *.9 blue:85/255.f *.9 alpha:1.f];
}

+ (UIColor *)shinobiPlayPurpleColor {
  return [UIColor colorWithRed:88/255.f *.8 green:86/255.f *.8 blue:214/255.f *.8 alpha:1.f];
}

+ (UIColor *)shinobiPlaySilverColor {
  return [UIColor colorWithRed:142/255.f green:142/255.f blue:147/255.f alpha:1.f];
}

+ (NSArray *)shinobiPlayColorArray {
  static dispatch_once_t onceToken = 0;
  dispatch_once(&onceToken, ^{
    shinobiPlayColors = @[[UIColor shinobiPlayBlueColor],
                          [UIColor shinobiPlayGreenColor],
                          [UIColor shinobiPlayOrangeColor],
                          [UIColor shinobiPlayRedColor],
                          [UIColor shinobiPlayPurpleColor],
                          [UIColor shinobiPlaySilverColor]];
  });
  
  return shinobiPlayColors;
}

- (UIColor *)shinobiBackgroundColor {
  CGFloat h, s, b, a;
  if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
    
  return [UIColor colorWithHue:h
                      saturation:0.1
                      brightness:0.95
                           alpha:a];
  }
  return nil;
}

- (UIColor *)shinobiLightColor {
  CGFloat h, s, b, a;
  if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
    
    return [UIColor colorWithHue:h
                      saturation:0.5
                      brightness:0.8
                           alpha:a];
  }
  return nil;
}

- (UIColor *)shinobiBrightColor {
  CGFloat h, s, b, a;
  if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
    
    return [UIColor colorWithHue:h
                      saturation:s
                      brightness:b+0.1
                           alpha:a];
  }
  return nil;
}

@end
