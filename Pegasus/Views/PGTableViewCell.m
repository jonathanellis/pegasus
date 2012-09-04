//
//  PGTableViewCell.m
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

#import "PGTableViewCell.h"

@implementation PGTableViewCell

@dynamic internalObject;

+ (id)internalObjectWithAttributes:(NSDictionary *)attributes {
    return [[UITableViewCell alloc] init];
}

+ (NSString *)name {
    return @"tableviewcell";
}

- (void)setUp {
    [super setUp];
    
    [self addVirtualProperty:@"text" dependencies:nil];
    [self addVirtualProperty:@"textFont" dependencies:nil];
    [self addVirtualProperty:@"detailText" dependencies:nil];
    [self addVirtualProperty:@"image" dependencies:nil];

    
    [self addPropertiesFromDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"BOOL", @"editing",
                                       @"BOOL", @"showsReorderControl",
                                       @"int", @"indentationLevel",
                                       @"float", @"indentationWidth",
                                       nil]];

}

- (void)setText:(NSString *)string {
    self.internalObject.textLabel.text = string;
}

- (void)setTextFont:(NSString *)string {
    self.internalObject.textLabel.font = [PGTranslators fontWithString:string];
}

- (void)detailText:(NSString *)string {
    self.internalObject.detailTextLabel.text = string;
}

- (void)setImage:(NSString *)string {
    self.internalObject.imageView.image = [PGTranslators imageWithString:string];
}

@end