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

#import "PGView.h"

@implementation PGView

@synthesize view;

+ (PGView *)viewWithString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self viewWithData:data];
}

+ (PGView *)viewWithContentsOfFile:(NSString *)file {
    NSData *data = [NSData dataWithContentsOfFile:file];
    return [self viewWithData:data];
}

+ (PGView *)viewWithData:(NSData *)data {
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:data options:0 error:nil];
    CXMLElement *rootElement = doc.rootElement;
    
    PGView *view = [PGView viewWithElement:rootElement];
    if (view) return view;
    
    NSLog(@"Pegasus Error: No corresponding class for root element '%@'. Ignoring and returning nil!", rootElement.name);
    return nil;
}

+ (PGView *)viewWithElement:(CXMLElement *)element {
    
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
                             nil];
    
    // Search for class matching the tag name
    for (NSString *adapter in adapters) {
        Class <PGAdapter> class = NSClassFromString(adapter);
        NSString *name = [class name];
        
        if ([name isEqualToString:element.name]) {
            PGView *view = [[(Class)class alloc] initWithElement:element];    
            return view;
        }
    }
    
    return nil;
}

- (id)initWithElement:(CXMLElement *)element {
    if (self = [super init]) {
        
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
                
        for (CXMLNode *attribute in element.attributes) {
            [attributes setObject:attribute.stringValue forKey:attribute.name];
        }

        view = [[self class] internalViewWithAttributes:attributes];
        subviews = [NSMutableArray array];

        
        NSDictionary *propertyTypes = [[self class] properties];
        
        for (NSString *attribute in attributes) {
        
            NSString *propertyName = attribute;
            NSString *propertyValue = [attributes objectForKey:attribute];       
            NSString *propertyType = [propertyTypes objectForKey:propertyName];            
            
            // Convert to lowercase if not a string/virtual:         
            if (![propertyType isEqualToString:@"NSString"] && ![propertyType isEqualToString:@"#"]) {
                propertyValue = [propertyValue lowercaseString];
            }
            
            if (!propertyType) {
                NSLog(@"Pegasus Error: No attribute '%@' on class %@. Ignoring!", propertyName, NSStringFromClass([self class]));
            } else {
                if ([propertyType isEqualToString:@"#"]) { // Virtual property
                    [self setValue:propertyValue forVirtualProperty:propertyName];
                } else if (![propertyType isEqualToString:@"*"]) {
                    [self setValue:propertyValue ofType:propertyType forProperty:propertyName];
                }
            }
        }
        
        // If this is a view (as opposed to a barbutton item, for instance):
        if ([view isKindOfClass:[UIView class]]) {
            
            // Finalize layout:
            if (!layout) layout = [[PGLayout alloc] init];

            layout.size = ((UIView *)view).frame.size;
            
            // Subviews:
            for (CXMLElement *childElement in element.children) {
                if ([childElement isKindOfClass:[CXMLElement class]]) {
                    PGView *subview = [PGView viewWithElement:childElement];
                    
                    if (subview) {
                        [self addSubview:subview];
                    } else {
                        NSLog(@"Pegasus Error: No corresponding class for element '%@'. Ignoring!", childElement.name);
                    }

                }
            }
            
            // Add views according to layout:
            [layout addViewsToSuperview:view];
                
        }
        
    }
    return self;
}

- (void)setValue:(NSString *)string ofType:(NSString *)type forProperty:(NSString *)property {
    // STEP 1 - Get Translator
    SEL translatorSelector = [PGTranslators translatorForType:type];
    
    // STEP 2 - Translate value
    void *value = [PGTranslators performSelector:translatorSelector withValue:&string];
    
    // STEP 3 - Get property setter selector
    SEL setPropertySelector = [self selectorForProperty:property];
        
    // STEP 4 - Set property
    [view performSelector:setPropertySelector withValue:value];
    
    free(value);
}

- (SEL)selectorForProperty:(NSString *)propertyName {
    NSString *capitalizedString = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[propertyName substringToIndex:1] capitalizedString]];
    
    NSString *selectorStr = [NSString stringWithFormat:@"set%@:", capitalizedString];
    
    return NSSelectorFromString(selectorStr);

}

- (UIView *)findViewWithID:(NSString *)viewID {    
    if ([_id isEqualToString:viewID]) return self.view;
    
    for (PGView *subview in subviews) {
        UIView *result = [subview findViewWithID:viewID];
        if (result) return result;
    }
    return nil;
}

- (NSArray *)findViewsInGroup:(NSString *)subviewGroup {
    NSMutableArray *result = [NSMutableArray array];
    if ([groups containsObject:subviewGroup]) [result addObject:self.view];

    for (PGView *subview in subviews) {
        [result addObjectsFromArray:[subview findViewsInGroup:subviewGroup]];
    }
    
    return result;
}

#pragma mark - PGViewAdapter methods

+ (id)internalViewWithAttributes:(NSDictionary *)attributes {
    return [[UIView alloc] init];
}

+ (NSString *)name {
    return @"view";
}

+ (NSDictionary *)properties {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"#", @"id",
            @"#", @"group",
            @"#", @"layout",
            @"#", @"size",
            @"#", @"origin",
            @"UIColor", @"backgroundColor",
            @"BOOL", @"hidden",
            @"float", @"alpha",
            @"BOOL", @"opaque",
            @"BOOL", @"clipToBounds",
            @"BOOL", @"clearsContexBeforeDrawing",
            @"BOOL", @"userInteractionEnabled",
            @"BOOL", @"multipleTouchEnabled",
            @"BOOL", @"exclusiveTouch",
            @"CGRect", @"frame",
            @"CGRect", @"bounds",
            @"CGPoint", @"center",
            @"CGAffineTransform", @"transform",
            @"UIViewAutoresizing", @"autoresizingMask",
            @"BOOL", @"autoresizesSubviews",
            @"UIViewContentMode", @"contentMode",
            @"CGRect", @"contentStretch",
            @"float", @"contentScaleFactor",
            @"int", @"tag",
            nil];
}


- (void)setValue:(NSString *)string forVirtualProperty:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]) {
        _id = [string lowercaseString];
    } else if ([propertyName isEqualToString:@"group"]) {
        groups = [[string lowercaseString] componentsSeparatedByString:@" "];
    } else if ([propertyName isEqualToString:@"layout"]) {
        layout = [PGLayout layoutWithString:string];
    } else if ([propertyName isEqualToString:@"size"]) {
        CGRect frame = ((UIView *)view).frame;
        frame.size = [PGTranslators sizeWithString:string];;
        ((UIView *)view).frame = frame;
    } else if ([propertyName isEqualToString:@"origin"]) {
        CGRect frame = ((UIView *)view).frame;
        frame.origin = [PGTranslators pointWithString:string];
        ((UIView *)view).frame = frame;
    }
}

- (void)addSubview:(PGView *)subview {
    [layout addView:subview.view];
    [subviews addObject:subview];
}


@end