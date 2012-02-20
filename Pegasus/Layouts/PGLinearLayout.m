//
//  PGLinearLayout.m
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

#import "PGLinearLayout.h"

@implementation PGLinearLayout

- (id)initWithString:(NSString *)string {
    if (self = [super init]) {
        NSArray *components = [string componentsSeparatedByString:@" "];
        NSString *orientationStr = [components objectAtIndex:1];
        if ([orientationStr isEqualToString:@"horizontal"]) {
            orientation = PGLinearLayoutOrientationHorizontal;
        } else if ([orientationStr isEqualToString:@"vertical"]) {
            orientation = PGLinearLayoutOrientationVertical;
        }
        if ([components count] > 2) {
            padding = [[components objectAtIndex:2] intValue];
        }
    }
    return self;
}

- (void)addView:(UIView *)view {
    
    CGRect frame = view.frame;
    
    UIView *lastView = [views lastObject];
    CGPoint origin;
    if (orientation == PGLinearLayoutOrientationHorizontal) {
        origin.x = lastView.frame.origin.x + lastView.frame.size.width + padding;
    } else { // PGLinearLayoutOrientationVertical
        origin.y = lastView.frame.origin.y + lastView.frame.size.height + padding;
    }
    frame.origin = origin;

    
    view.frame = frame;
    [super addView:view];
}

@end
