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

+ (id)internalViewWithAttributes:(NSDictionary *)attributes {
    return [[UITableViewCell alloc] init];
}

+ (NSString *)name {
    return @"tableviewcell";
}

+ (NSDictionary *)properties {
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"#", @"text",
                                       @"#", @"text-font",
                                    //   @"#", @"detail-text",
                                       @"#", @"image",
                                       @"BOOL", @"editing",
                                       @"BOOL", @"showsReorderControl",
                                       @"int", @"indentationLevel",
                                       @"float", @"indentationWidth",
                                       nil];
    
    [properties addEntriesFromDictionary:[PGView properties]];
    
    return properties;
}

- (void)setValue:(NSString *)string forVirtualProperty:(NSString *)property {
    [super setValue:string forVirtualProperty:property];
    
    UITableViewCell *tableViewCell = (UITableViewCell *)view;
    
    if ([property isEqualToString:@"text"]) {
        tableViewCell.textLabel.text = string;
    } else if ([property isEqualToString:@"text-font"]) {
        tableViewCell.textLabel.font = [PGTranslators fontWithString:string];
    } else if ([property isEqualToString:@"detail-text"]) {
        tableViewCell.detailTextLabel.text = string;
    } else if ([property isEqualToString:@"image"]) {
        tableViewCell.imageView.image = [PGTranslators imageWithString:string];
    }
    
}

@end