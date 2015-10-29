//
//  SPUManagedGalleryViewController.m
//  ShinobiPlayUtils
//
//  Created by Alison Clarke on 24/06/2014.
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

#import "SPUGalleryManagedViewController.h"

@interface SPUGalleryManagedViewController ()

@property (nonatomic, assign) CGRect frame;

@end

@implementation SPUGalleryManagedViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.needsOverlayOnLoad = NO;
  }
  return self;
}

- (instancetype)initWithViewFrame:(CGRect)frame {
  self = [super init];
  if (self) {
    self.frame = frame;
    self.needsOverlayOnLoad = NO;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (!CGRectIsEmpty(self.frame)) {
    self.view.frame = self.frame;
  }
}

- (void)preLoadData {
  // Implement in subclasses if there's any data that can be loaded on a background thread
  // before the view controller appears
}

+ (instancetype)viewControllerFromStoryboard:(NSString *)storyboardName viewFrame:(CGRect)frame {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
  UIViewController *vc = [storyboard instantiateInitialViewController];
  return [SPUGalleryManagedViewController checkViewController:vc andSetViewFrame:frame];
}

+ (instancetype)viewControllerFromStoryboard:(NSString *)storyboardName identifier:(NSString *)identifier
                                   viewFrame:(CGRect)frame {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
  UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:identifier];
  return [SPUGalleryManagedViewController checkViewController:vc andSetViewFrame:frame];
}

+ (instancetype)checkViewController:(UIViewController*)vc andSetViewFrame:(CGRect)frame {
  if ([vc isKindOfClass:[SPUGalleryManagedViewController class]]) {
    SPUGalleryManagedViewController *svc = (SPUGalleryManagedViewController *) vc;
    svc.frame = frame;
    return svc;
  } else {
    return nil;
  }
}

@end
