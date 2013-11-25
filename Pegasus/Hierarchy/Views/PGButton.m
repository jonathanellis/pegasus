//
//  PGButton.m
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

#import "PGButton.h"

@implementation PGButton

@dynamic internalObject;

+ (id)internalObjectWithAttributes:(NSDictionary *)attributes {
    NSString *buttonTypeStr = [[attributes objectForKey:@"buttonType"] lowercaseString];
    UIButtonType buttonType = [PGTransformers buttonTypeWithString:buttonTypeStr];      
    return [UIButton buttonWithType:buttonType];
}

+ (NSString *)name {
    return @"button";
}

- (void)setUp {
    [super setUp];
    
    [self addVirtualProperty:@"title" dependencies:nil];
    [self addVirtualProperty:@"backgroundImage" dependencies:nil];
    
    
    [self addPropertiesFromDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"*", @"buttonType",
                                       @"UIEdgeInsets", @"contentEdgeInsets",
                                       @"UIEdgeInsets", @"titleEdgeInsets",
                                       @"UIEdgeInsets", @"imageEdgeInsets",
                                       nil]];

}

#pragma mark - Virtual Properties

- (void)setTitle:(NSString *)string {
    [self.internalObject setTitle:string forState:UIControlStateNormal];
}

- (void)setBackgroundImage:(NSString *)string {
    [self.internalObject setBackgroundImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
}

@end
