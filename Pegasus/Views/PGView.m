//
//  PGView.m
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

#import "PGView.h"

@implementation PGView

@dynamic internalObject;

+ (id)internalObjectWithAttributes:(NSDictionary *)attributes {
    return [[UIView alloc] init];
}

+ (NSString *)name {
    return @"view";
}

- (void)setUp {
    [super setUp];
    
    [self addVirtualProperty:@"size" dependencies:[NSArray arrayWithObjects:@"^.frame.size", nil]];
    [self addVirtualProperty:@"origin" dependencies:[NSArray arrayWithObjects:@"^.frame.size", nil]];
    [self addVirtualProperty:@"width" dependencies:[NSArray arrayWithObjects:@"^.frame.size.width", nil]];
    [self addVirtualProperty:@"height" dependencies:[NSArray arrayWithObjects:@"^.frame.size.height", nil]];
    [self addVirtualProperty:@"x" dependencies:[NSArray arrayWithObjects:@"^.frame.size.width", nil]];
    [self addVirtualProperty:@"y" dependencies:[NSArray arrayWithObjects:@"^.frame.size.height", nil]];

    [self addPropertiesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                       @"UIColor", @"backgroundColor",
                                       @"BOOL", @"hidden",
                                       @"float", @"alpha",
                                       @"BOOL", @"opaque",
                                       @"BOOL", @"clipToBounds",
                                       @"BOOL", @"clearsContexBeforeDrawing",
                                       @"BOOL", @"userInteractionEnabled",
                                       @"BOOL", @"multipleTouchEnabled",
                                       @"BOOL", @"exclusiveTouch",
                                       @"CGRect", @"frame",
                                       @"CGRect", @"bounds",
                                       @"CGPoint", @"center",
                                       @"CGAffineTransform", @"transform",
                                       @"UIViewAutoresizing", @"autoresizingMask",
                                       @"BOOL", @"autoresizesSubviews",
                                       @"UIViewContentMode", @"contentMode",
                                       @"CGRect", @"contentStretch",
                                       @"float", @"contentScaleFactor",
                                       @"int", @"tag",
                                       nil]];
}

- (void)addChild:(PGObject *)childObject {
    [super addChild:childObject];
    [internalObject addSubview:childObject.internalObject];
}

#pragma mark - Virtual Properties

- (void)setSize:(NSString *)string {
    CGRect frame = [self internalFrame];
    frame.size = [PGTranslators sizeWithString:string withParentSize:[self parentFrame].size];
    self.internalObject.frame = frame;
}

- (void)setOrigin:(NSString *)string {
    CGRect frame = [self internalFrame];
    frame.origin = [PGTranslators pointWithString:string withParentSize:[self parentFrame].size];
    self.internalObject.frame = frame;
}

- (void)setWidth:(NSString *)string {
    CGRect frame = [self internalFrame];
    frame.size.width = [PGTranslators floatWithString:string withParentFloat:[self parentFrame].size.width];
    self.internalObject.frame = frame;
}

- (void)setHeight:(NSString *)string {
    CGRect frame = [self internalFrame];
    frame.size.height = [PGTranslators floatWithString:string withParentFloat:[self parentFrame].size.height];
    self.internalObject.frame = frame;
}

- (void)setX:(NSString *)string {
    CGRect frame = [self internalFrame];
    frame.origin.x = [PGTranslators floatWithString:string withParentFloat:[self parentFrame].size.width];
    self.internalObject.frame = frame;
}

- (void)setY:(NSString *)string {
    CGRect frame = [self internalFrame];
    frame.origin.y = [PGTranslators floatWithString:string withParentFloat:[self parentFrame].size.height];
    self.internalObject.frame = frame;
}

#pragma mark - Helper Methods


- (CGRect)internalFrame {
    UIView *internalView = internalObject;
    return internalView.frame;
}

- (CGRect)parentFrame {
    UIView *parentView = parent.internalObject;
    return parentView ? parentView.frame : [[UIScreen mainScreen] bounds];
}

@end
