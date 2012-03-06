//
//  Tuple.m
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

#import "Tuple.h"

@implementation Tuple

@synthesize children;

- (id)initWithString:(NSString *)string {
    NSScanner *scanner = [NSScanner scannerWithString:string];
    return [self initWithScanner:scanner];
}

- (id)initWithScanner:(NSScanner *)scanner {
    if (self = [super init]) {
        children = [NSMutableArray array];
        
        [scanner scanString:@"{" intoString:NULL]; // consume opening brace
        
        while (![scanner isAtEnd]) {
            if ([scanner scanString:@"{" intoString:NULL]) { // New sub-tuple
                Tuple *t = [[Tuple alloc] initWithScanner:scanner];
                [children addObject:t];
            } else if ([scanner scanString:@"}" intoString:NULL]) { // End of sub-tuple
                [scanner scanString:@"," intoString:NULL]; // consume comma if comma follows
                return self;
            } else {
                NSString *str;
                [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@",}"] intoString:&str];
                [children addObject:str];
                [scanner scanString:@"," intoString:NULL];
            }
        }
    }
    return self;
}

// Useful for debugging:
- (NSString *)description {
    NSMutableString *result = [NSMutableString stringWithString:@"{"];
    [result appendString:[children componentsJoinedByString:@", "]];
    [result appendString:@"}"];
    return result;
}

@end
