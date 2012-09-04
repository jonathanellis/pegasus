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

#import "PGObject.h"

@implementation PGObject

@synthesize internalObject;
@synthesize parent;

+ (PGObject *)viewWithString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self viewWithData:data];
}

+ (PGObject *)viewWithContentsOfFile:(NSString *)file {
    NSData *data = [NSData dataWithContentsOfFile:file];
    return [self viewWithData:data];
}

+ (PGObject *)viewWithData:(NSData *)data {
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:data options:0 error:nil];
    CXMLElement *rootElement = doc.rootElement;
    
    PGObject *view = [PGObject viewWithElement:rootElement superview:nil];
    if (view) return view;
    
    NSLog(@"Pegasus Error: No corresponding class for root element '%@'. Ignoring and returning nil!", rootElement.name);
    return nil;
}

+ (PGObject *)viewWithElement:(CXMLElement *)element superview:(PGObject *)aSuperview {
    
    NSArray *adapters = [NSArray arrayWithObjects:
                             @"PGView",
                             @"PGScrollView",
                             @"PGLabel",
                             @"PGImageView",
                             @"PGTextField",
                             @"PGButton",
                             @"PGSwitch",
                             @"PGProgressView",
                             @"PGTableView",
                             @"PGTableViewCell",
                             @"PGToolbar",
                             @"PGBarButtonItem",
                             @"PGLinearLayout",
                             @"PGGridLayout",
                             nil];
    
    // Search for class matching the tag name
    for (NSString *adapter in adapters) {
        Class <PGAdapter> class = NSClassFromString(adapter);
        NSString *name = [class name];
        
        if ([name isEqualToString:element.name]) {
            PGObject *object = [[(Class)class alloc] initWithElement:element parent:aSuperview];
            return object;
        }
    }
    
    return nil;
}

- (id)initWithElement:(CXMLElement *)element parent:(PGObject *)aParent {
    if (self = [super init]) {
        parent = aParent;
                
        properties = [NSMutableDictionary dictionary];
        dependencies = [NSMutableDictionary dictionary];
        
        [self setUp];
        
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
                
        for (CXMLNode *attribute in element.attributes) {
            [attributes setObject:attribute.stringValue forKey:attribute.name];
        }

        internalObject = [[self class] internalObjectWithAttributes:attributes];
        
        for (NSString *attribute in attributes) {
        
            NSString *propertyName = attribute;
            NSString *propertyValue = [attributes objectForKey:attribute];       
            NSString *propertyType = [properties objectForKey:propertyName];
            
            // Convert to lowercase if not a string/virtual:         
            if (![propertyType isEqualToString:@"NSString"] && ![propertyType isEqualToString:@"#"]) {
                propertyValue = [propertyValue lowercaseString];
            }
            
            if (!propertyType) {
                NSLog(@"Pegasus Error: No attribute '%@' on class %@. Ignoring!", propertyName, NSStringFromClass([self class]));
            } else {
                if ([propertyType isEqualToString:@"#"]) { // Virtual property
                    SEL selector = [self selectorForProperty:propertyName];
                    [self performSelector:selector withObject:propertyValue];
                } else if ([propertyType isEqualToString:@"CGRect"] ||
                           [propertyType isEqualToString:@"CGSize"] ||
                           [propertyType isEqualToString:@"CGPoint"]) {
                    [self setValue:propertyValue ofSpecialType:propertyType forProperty:propertyName];
                } else if (![propertyType isEqualToString:@"*"]) {
                    [self setValue:propertyValue ofType:propertyType forProperty:propertyName];
                }
            }
        }
        
        // If this is a view (as opposed to a barbutton item, for instance):
        if ([internalObject isKindOfClass:[UIView class]]) {
            
            // Subviews:
            for (CXMLElement *childElement in element.children) {
                if ([childElement isKindOfClass:[CXMLElement class]]) {

                    PGObject *subview = [PGObject viewWithElement:childElement superview:self];

                    if (subview) {
                        [self addChild:subview];
                    } else {
                        NSLog(@"Pegasus Error: No corresponding class for element '%@'. Ignoring!", childElement.name);
                    }

                }
            }
                
        }
        
    }
    return self;
}

- (void)setValue:(NSString *)string ofType:(NSString *)type forProperty:(NSString *)propertyName {
    // STEP 1 - Get Translator
    SEL translatorSelector = [PGTranslators translatorForType:type];
    
    // STEP 2 - Translate value
    void *value = [PGTranslators performSelector:translatorSelector withValue:&string];
    
    // STEP 3 - Get property setter selector
    SEL setPropertySelector = [self selectorForProperty:propertyName];
        
    // STEP 4 - Set property
    [internalObject performSelector:setPropertySelector withValue:value];
    
    free(value);
}

- (void)setValue:(NSString *)string ofSpecialType:(NSString *)type forProperty:(NSString *)propertyName {
    SEL setPropertySelector = [self selectorForProperty:propertyName];
    
    UIView *parentInternalView = parent.internalObject;
    if ([type isEqualToString:@"CGRect"]) {
        CGRect parentRect = parent ? parentInternalView.frame : [[UIScreen mainScreen] bounds];
        CGRect rect = [PGTranslators rectWithString:string withParentRect:parentRect];
        [internalObject performSelector:setPropertySelector withValue:&rect];
    } else if ([type isEqualToString:@"CGSize"]) {
        CGSize parentSize = parent ? parentInternalView.frame.size : [[UIScreen mainScreen] bounds].size;
        CGSize size = [PGTranslators sizeWithString:string withParentSize:parentSize];
        [internalObject performSelector:setPropertySelector withValue:&size];
    } else if ([type isEqualToString:@"CGPoint"]) {
        CGSize parentSize = parent ? parentInternalView.frame.size : [[UIScreen mainScreen] bounds].size;
        CGPoint point = [PGTranslators pointWithString:string withParentSize:parentSize];
        [internalObject performSelector:setPropertySelector withValue:&point];
    }
}

- (SEL)selectorForProperty:(NSString *)propertyName {
    NSString *capitalizedString = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[propertyName substringToIndex:1] capitalizedString]];
    
    NSString *selectorStr = [NSString stringWithFormat:@"set%@:", capitalizedString];
    
    return NSSelectorFromString(selectorStr);

}

- (UIView *)findViewWithID:(NSString *)viewID {    
    if ([_id isEqualToString:viewID]) return self.internalObject;
    
    for (PGObject *subview in children) {
        UIView *result = [subview findViewWithID:viewID];
        if (result) return result;
    }
    return nil;
}

- (NSArray *)findViewsInGroup:(NSString *)subviewGroup {
    NSMutableArray *result = [NSMutableArray array];
    if ([groups containsObject:subviewGroup]) [result addObject:self.internalObject];

    for (PGObject *subview in children) {
        [result addObjectsFromArray:[subview findViewsInGroup:subviewGroup]];
    }
    
    return result;
}

#pragma mark - Top-Level Object Methods

- (void)addVirtualProperty:(NSString *)propertyName dependencies:(NSArray *)propertyDependencies {
    if (propertyDependencies) { // Cannot add nil to NSArray -- if it has no dependencies, then ignore.
        [dependencies setObject:propertyDependencies forKey:propertyName];
    }
    [properties setObject:@"#" forKey:propertyName];
}

- (void)addProperty:(NSString *)propertyName ofType:(NSString *)type {
    [properties setObject:type forKey:propertyName];
}

- (void)addPropertiesFromDictionary:(NSDictionary *)dictionary {
    for (NSString *property in dictionary) {
        NSString *type = [dictionary objectForKey:property];
        [self addProperty:property ofType:type];
    }
}

#pragma mark - PGAdapter Methods

+ (id)internalObjectWithAttributes:(NSDictionary *)attributes {
    return [[NSObject alloc] init];
}

+ (NSString *)name {
    return @"object";
}

- (void)addChild:(PGObject *)childObject {
    if (!children) children = [NSMutableArray array];
    [children addObject:childObject];
}

- (void)setUp {
    [self addVirtualProperty:@"id" dependencies:nil];
    [self addVirtualProperty:@"group" dependencies:nil];
}

#pragma mark - Virtual Properties

- (void)setId:(NSString *)string {
    _id = [string lowercaseString];
}

- (void)setGroup:(NSString *)string {
    groups = [[string lowercaseString] componentsSeparatedByString:@" "];
}

@end