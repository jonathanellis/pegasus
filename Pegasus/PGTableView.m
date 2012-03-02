//
//  PGTableView.m
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

#import "PGTableView.h"

@implementation PGTableView

+ (UIView *)internalViewWithAttributes:(NSDictionary *)attributes {
    NSString *tableViewStyleStr = [attributes objectForKey:@"style"];
    UITableViewStyle tableViewStyle = [PGTranslators tableViewStyleWithString:tableViewStyleStr];      
    return [[UITableView alloc] initWithFrame:CGRectZero style:tableViewStyle];
}

+ (NSString *)name {
    return @"tableview";
}

+ (NSDictionary *)properties {
    
    NSMutableDictionary *properties =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"*", @"style",
                                      @"float", @"rowHeight",
                                      @"UITableViewCellSeparatorStyle", @"separatorStyle", 
                                      @"UITextAlignment", @"textAlignment",
                                      @"UIColor", @"separatorColor",
                                   //   @"UIView", @"backgroundView",
                                   //   @"UIView", @"tableHeaderView",
                                   //   @"UIView", @"tableFooterView",
                                      @"float", @"sectionHeaderHeight",
                                      @"float", @"sectionFooterHeight",
                                      @"int", @"sectionIndexMinimumDisplayRowCount", 
                                      @"BOOL", @"allowsSelection",
                                      @"BOOL", @"allowsMultipleSelection",
                                      @"BOOL", @"allowsSelectionDuringEditing",
                                      @"BOOL", @"allowsMultipleSelectionDuringEditing",
                                      @"BOOL", @"editing",
                                      nil];
    
    [properties addEntriesFromDictionary:[PGView properties]];
    
    return properties;
}

- (void)addSubview:(PGView *)subview {
    if ([subview isKindOfClass:[PGTableViewCell class]]) {
        if (!cells) {
            cells = [NSMutableArray array];
            UITableView *tableView = (UITableView *)view;
            tableView.dataSource = self;
        }
        [cells addObject:subview.view];
    } else {
        [super addSubview:subview];
    }
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [cells objectAtIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cells count];
}

@end
