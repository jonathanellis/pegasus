//
//  PGLayout.m
//  Pegasus
//
//  Copyright 2012 Jonathan Ellis
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

#import "PGLayout.h"

@implementation PGLayout

- (id)init {
    if (self = [super init]) {
        views = [NSMutableArray array];
    }
    return self;
}

- (void)addViewsToSuperview:(UIView *)superview {
    for (UIView *view in views) {
        [superview addSubview:view];
    }
}

- (void)addView:(UIView *)view {
    [views addObject:view];
}

@end
