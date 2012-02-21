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

+ (NSString *)name {
    return @"button";
}

+ (NSDictionary *)properties {
    
    NSMutableDictionary *properties =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"#", @"title",
                                      @"#", @"backgroundImage",
                                      @"UIColor", @"tintColor",
                                      @"UIEdgeInsets", @"contentEdgeInsets",
                                      @"UIEdgeInsets", @"titleEdgeInsets",
                                      @"UIEdgeInsets", @"imageEdgeInsets",
                                      nil];
    
    [properties addEntriesFromDictionary:[PGView properties]];
    
    return properties;
}

+ (Class)underlyingClass {
    return [UIButton class];
}

- (void)setValue:(NSString *)string forVirtualProperty:(NSString *)property {
    [super setValue:string forVirtualProperty:property];
    
    UIButton *button = (UIButton *)view;
    
    if ([property isEqualToString:@"title"]) {
        [button setTitle:string forState:UIControlStateNormal];
    } else if ([property isEqualToString:@"backgroundImage"]) {
        [button setBackgroundImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    }
    
}

@end
