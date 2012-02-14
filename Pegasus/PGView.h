//
//  PGView.h
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

#import <UIKit/UIKit.h>

#import "PGAdapter.h"

@interface PGView : NSObject <PGAdapter> {
    
    NSString *__id;
    NSArray *tags;
    
    UIView *view;
    NSMutableArray *subviews;
}

@property (nonatomic, strong) UIView *view;

+ (PGView *)viewWithContentsOfFile:(NSString *)file;
+ (PGView *)viewWithElement:(CXMLElement *)element;

- (id)initWithElement:(CXMLElement *)element;

- (void)setValue:(NSString *)string ofType:(NSString *)type forProperty:(NSString *)propertyValue;
- (SEL)selectorForProperty:(NSString *)propertyName;

- (UIView *)findViewWithID:(NSString *)viewID;
- (NSArray *)findViewsWithTag:(NSString *)subviewTag;


@end