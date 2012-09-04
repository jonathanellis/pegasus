//
//  PGCenterLayout.m
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

#import "PGCenterLayout.h"

@implementation PGCenterLayout
/*
- (id)initWithSuperview:(UIView *)aSuperview string:(NSString *)string {
    if (self = [super initWithSuperview:aSuperview]) {
        NSArray *components = [string componentsSeparatedByString:@" "];
        NSString *orientationStr = [components objectAtIndex:1];
        if ([orientationStr isEqualToString:@"horizontal"]) {
            orientation = PGCenterLayoutOrientationHorizontal;
        } else if ([orientationStr isEqualToString:@"vertical"]) {
            orientation = PGCenterLayoutOrientationVertical;
        }
        if ([components count] > 2) {
            padding = [[components objectAtIndex:2] intValue];
        }
    }
    return self;
}

- (void)addView:(UIView *)view {
    
    UIView *lastView = [views lastObject];
    CGPoint center = CGPointMake(size.width/2.0, size.height/2.0);
    
    if (orientation == PGLinearLayoutOrientationHorizontal) {
        center.x = lastView.frame.origin.x + lastView.frame.size.width + padding + (0.5 * view.frame.size.width);
    } else { // PGCenterLayoutOrientationVertical
        center.y = lastView.frame.origin.y + lastView.frame.size.height + padding + (0.5 * view.frame.size.height);
    }

    view.center = center;
    
    NSLog(@"view center = %@", NSStringFromCGPoint(center));
    
    [super addView:view];
}*/

@end
