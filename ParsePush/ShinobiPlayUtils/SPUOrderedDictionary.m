//
//  SPUOrderedDictionary.m
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

#import "SPUOrderedDictionary.h"

@interface SPUOrderedDictionary ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation SPUOrderedDictionary

- (instancetype)init {
  self = [super init];
  if (self != nil) {
    self.dictionary = [NSMutableDictionary dictionary];
    self.array = [NSMutableArray array];
  }
  return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
  self = [super init];
  if (self != nil) {
    self.dictionary = [NSMutableDictionary dictionaryWithCapacity:numItems];
    self.array = [NSMutableArray arrayWithCapacity:numItems];
  }
  return self;
}

+ (instancetype)dictionary {
  return [[[SPUOrderedDictionary class] alloc] init];
}

- (void)setObject:(id)anObject forKey:(id)aKey {
  if (!self.dictionary[aKey]) {
    [self.array addObject:aKey];
  }
  self.dictionary[aKey] = anObject;
}

- (void)removeObjectForKey:(id)aKey {
  [self.dictionary removeObjectForKey:aKey];
  [self.array removeObject:aKey];
}

- (NSUInteger)count {
  return self.dictionary.count;
}

- (id)objectForKey:(id)aKey {
  return self.dictionary[aKey];
}

- (NSEnumerator *)keyEnumerator {
  return [self.array objectEnumerator];
}

- (id)keyAtIndex:(NSUInteger)index    {
  return self.array[index];
}

- (id)objectAtIndex:(NSUInteger)index {
  return self[self.array[index]];
}

@end
