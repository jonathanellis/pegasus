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

- (id)initWithString:(NSString *)string {
    if (self = [super init]) {
        NSArray *components = [string componentsSeparatedByString:@" "];
        
        Tuple *dimensionsTuple = [[Tuple alloc] initWithString:[components objectAtIndex:1]];
        rows = [[dimensionsTuple.children objectAtIndex:0] intValue];
        cols = [[dimensionsTuple.children objectAtIndex:1] intValue];
        
        Tuple *paddingsTuple = [[Tuple alloc] initWithString:[components objectAtIndex:2]];
        rowPadding = [[paddingsTuple.children objectAtIndex:0] intValue];
        colPadding = [[paddingsTuple.children objectAtIndex:1] intValue];
        
    }
    return self;
}

- (void)addView:(UIView *)view {
    
    CGRect frame = view.frame;
    
    int cellColPadding = (float)(cols+1)/cols * colPadding;
    int cellWidth = (size.width/cols) - cellColPadding;

    
    int rowColPadding = (float)(rows+1)/rows * rowPadding;
    int cellHeight = (size.height/rows) - rowColPadding;
    
    CGSize cellSize = CGSizeMake(cellWidth, cellHeight);
    frame.size = cellSize;
    
    int n = [views count];
    
    if (n == 0) {
        frame.origin = CGPointMake(colPadding, rowPadding);
    } else {
        int nx = (n % cols); // number on the x axis
        int x = (nx * cellSize.width) + ((nx+1) * colPadding);
        
        int ny = (n / cols); // number on the y axis
        int y = (ny * cellSize.height) + ((ny+1) * rowPadding);
        
        
        frame.origin = CGPointMake(x, y);
    }
    
    view.frame = frame;
    [super addView:view];
}

@end
