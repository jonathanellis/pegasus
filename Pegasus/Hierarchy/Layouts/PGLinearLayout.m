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

+ (NSString *)name {
    return @"linearlayout";
}

- (void)setUp {
    [super setUp];
    [self addVirtualProperty:@"orientation" dependencies:nil];
    [self addVirtualProperty:@"padding" dependencies:[NSArray arrayWithObjects:@"frame.size", @"orientation", nil]];
}


- (void)addChild:(PGObject *)childObject {
    
    PGObject *prevChild = [children lastObject];
    
    CGPoint p;
    
    if (!prevChild) {
        if (orientation == PGLinearLayoutOrientationVertical) p.y = padding;
        else if (orientation == PGLinearLayoutOrientationHorizontal) p.x = padding;
    } else {
        UIView *prevChildView = prevChild.internalObject;
        if (orientation == PGLinearLayoutOrientationVertical) p.y = prevChildView.frame.origin.y + prevChildView.frame.size.height + padding;
        else if (orientation == PGLinearLayoutOrientationHorizontal) p.x = prevChildView.frame.origin.x + prevChildView.frame.size.width + padding;
    }
    
    UIView *childView = childObject.internalObject;
    CGRect childFrame = childView.frame;
    childFrame.origin = p;
    childView.frame = childFrame;
    
    [super addChild:childObject];
}

#pragma mark - Virtual Properties

- (void)setOrientation:(NSString *)string {
    if ([string isEqualToString:@"horizontal"] ||
        [string isEqualToString:@"h"] ||
        [string isEqualToString:@"landscape"]) {
        orientation = PGLinearLayoutOrientationHorizontal;
    } else if ([string isEqualToString:@"vertical"] ||
               [string isEqualToString:@"v"] ||
               [string isEqualToString:@"portrait"]) {
        orientation = PGLinearLayoutOrientationVertical;
    } else {
        NSLog(@"Pegasus Error: You have not specified a valid orientation. Valid options for are: horizontal | vertical | landscape | portrait | h | v.");
    }
}

- (void)setPadding:(NSString *)string {
    CGFloat parentFloat = 0.0f;
    if (orientation == PGLinearLayoutOrientationHorizontal) parentFloat = self.internalObject.frame.size.width;
    else if (orientation == PGLinearLayoutOrientationVertical) parentFloat = self.internalObject.frame.size.height;
    padding = [PGTranslators floatWithString:string withParentFloat:parentFloat];
}


@end
