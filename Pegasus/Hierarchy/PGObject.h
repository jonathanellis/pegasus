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

@class PGLayout;

@interface PGObject : NSObject <PGAdapter> {
    
    NSString *_id;
    NSArray *groups;
    
    id internalObject;
    NSMutableArray *children;
    PGObject *parent;
    
    NSMutableDictionary *properties;
    NSMutableDictionary *dependencies;
}

@property (nonatomic, readonly) id internalObject;
@property (nonatomic, readonly) PGObject *parent;

+ (PGObject *)viewWithString:(NSString *)string;
+ (PGObject *)viewWithContentsOfFile:(NSString *)file;
+ (PGObject *)viewWithData:(NSData *)data;

+ (PGObject *)viewWithElement:(CXMLElement *)element superview:(PGObject *)aSuperview;

- (id)initWithElement:(CXMLElement *)element parent:(PGObject *)aParent;

- (void)setValue:(NSString *)string ofType:(NSString *)type forProperty:(NSString *)propertyName;
- (void)setValue:(NSString *)string ofSpecialType:(NSString *)type forProperty:(NSString *)propertyName;
- (SEL)selectorForProperty:(NSString *)propertyName;

- (UIView *)findViewById:(NSString *)viewID;
- (NSArray *)findViewsInGroup:(NSString *)subviewGroup;
- (void)addVirtualProperty:(NSString *)propertyName dependencies:(NSArray *)dependencies;
- (void)addProperty:(NSString *)propertyName ofType:(NSString *)type;
- (void)addPropertiesFromDictionary:(NSDictionary *)dictionary;

@end