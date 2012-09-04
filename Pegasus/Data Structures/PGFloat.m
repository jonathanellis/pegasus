//
//  PGFloat.m
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

#import "PGFloat.h"

@implementation PGFloat

@dynamic value;
@synthesize isRelative;

- (id)initWithString:(NSString *)string relativeTo:(float)aRelativeTo {
    if (self = [super init]) {
        if ([string rangeOfString:@"%"].location != NSNotFound) { // Relative value
            NSCharacterSet *percentageSet = [NSCharacterSet characterSetWithCharactersInString:@"%"];
            NSString *trimmedString = [string stringByTrimmingCharactersInSet:percentageSet];
            fraction = [trimmedString floatValue] / 100.0;
            isRelative = YES;
        } else {
            absoluteValue = [string floatValue];
            isRelative = NO;
        }
        
        relativeTo = aRelativeTo;
    }
    return self;
}

- (float)value {
    if (isRelative) return fraction * relativeTo;
    return absoluteValue;
}

@end
