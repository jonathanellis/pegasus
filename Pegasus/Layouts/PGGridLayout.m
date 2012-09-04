//
//  PGGridLayout.m
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

#import "PGGridLayout.h"

@implementation PGGridLayout

+ (NSString *)name {
    return @"gridlayout";
}

- (void)setUp {
    [super setUp];
    
    [self addVirtualProperty:@"rows" dependencies:nil];
    [self addVirtualProperty:@"cols" dependencies:nil];
    [self addVirtualProperty:@"hPadding" dependencies:[NSArray arrayWithObject:@"^.frame.size.height"]];
    [self addVirtualProperty:@"vPadding" dependencies:[NSArray arrayWithObject:@"^.frame.size.width"]];
    
}

- (void)addChild:(PGObject *)childObject {
    UIView *internalView = internalObject;
    UIView *childView = childObject.internalObject;
    
    CGRect childFrame = childView.frame;
    
    int cellColPadding = (float)(cols+1)/cols * vPadding;
    int cellWidth = (internalView.frame.size.width/cols) - cellColPadding;
    
    int rowColPadding = (float)(rows+1)/rows * hPadding;
    int cellHeight = (internalView.frame.size.height/rows) - rowColPadding;
    
    CGSize cellSize = CGSizeMake(cellWidth, cellHeight);
    childFrame.size = cellSize;
    
    int n = [children count];
    
    if (n == 0) {
        childFrame.origin = CGPointMake(vPadding, hPadding);
    } else {
        int nx = (n % cols); // number on the x axis
        int x = (nx * cellSize.width) + ((nx+1) * vPadding);
        
        int ny = (n / cols); // number on the y axis
        int y = (ny * cellSize.height) + ((ny+1) * hPadding);
        
        
        childFrame.origin = CGPointMake(x, y);
    }
    
    childView.frame = childFrame;
    
    [super addChild:childObject];
}

#pragma mark - Virtual Properties

- (void)setRows:(NSString *)string {
    rows = [string intValue];
}

- (void)setCols:(NSString *)string {
    cols = [string intValue];
}

- (void)setVPadding:(NSString *)string {
    vPadding = [PGTranslators floatWithString:string withParentFloat:self.internalObject.frame.size.height];
}

- (void)setHPadding:(NSString *)string {
    hPadding = [PGTranslators floatWithString:string withParentFloat:self.internalObject.frame.size.width];
}

@end
