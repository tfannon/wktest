//
//  SPUOrderedDictionary.h
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

@import Foundation;

/**
   A mutable dictionary which maintains ordering of its keys.  The implementation is based on the blog post from Matt Gallagher (http://cocoawithlove.com/2008/12/ordereddictionary-subclassing-cocoa.html).
 */
@interface SPUOrderedDictionary : NSMutableDictionary

- (id)keyAtIndex:(NSUInteger)index;
- (id)objectAtIndex:(NSUInteger)index;

@end
