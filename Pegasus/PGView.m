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

+ (PGView *)viewWithContentsOfFile:(NSString *)file {
    NSData *xmlData = [NSData dataWithContentsOfFile:file];
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    
    CXMLElement *rootElement = doc.rootElement;
    
    PGView *view = [PGView viewWithElement:rootElement];
    if (view) return view;
    
    NSLog(@"Pegasus Error: No corresponding class for root tag '%@'. Ignoring and returning nil!", rootElement.name);
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
        
        Class underlyingClass = [[self class] underlyingClass];
        view = [[underlyingClass alloc] init];
        subviews = [NSMutableArray array];

        NSDictionary *properties = [[self class] properties];
                
        for (CXMLNode *attribute in element.attributes) {
            NSString *propertyName = attribute.name;
            NSString *propertyValue = attribute.stringValue;
            
            
            if ([propertyName isEqualToString:@"id"]) { // Special case: id
                __id = [propertyValue lowercaseString];
            } else if ([propertyName isEqualToString:@"tag"]) { // Special case: tag(s)
                tags = [[propertyValue lowercaseString] componentsSeparatedByString:@" "];
            } else { // All other attributes
            
                NSString *propertyType = [properties objectForKey:propertyName];
                
                // Convert to lowercase if not a string/virtual:
                if (![propertyType isEqualToString:@"NSString"]) {
                    propertyValue = [propertyValue lowercaseString];
                }
                
                if (!propertyType) {
                    NSLog(@"Pegasus Error: No attribute '%@' on class %@. Ignoring!", propertyName, NSStringFromClass([self class]));
                } else {
                    if ([propertyType isEqualToString:@"#"]) { // Virtual property
                        [self setValue:propertyValue forVirtualProperty:propertyName];
                    } else {
                        [self setValue:propertyValue ofType:propertyType forProperty:propertyName];
                    }
                }
            }
        }
        
        // Subviews:
        for (CXMLElement *childElement in element.children) {
            if ([childElement isKindOfClass:[CXMLElement class]]) {
                PGView *subview = [PGView viewWithElement:childElement];
                
                if (subview) {
                    [view addSubview:subview.view];
                    [subviews addObject:subview];
                } else {
                    NSLog(@"Pegasus Error: No corresponding class for tag '%@'. Ignoring!", childElement.name);
                }

            }
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
    if ([__id isEqualToString:viewID]) return self.view;
    
    for (PGView *subview in subviews) {
        UIView *result = [subview findViewWithID:viewID];
        if (result) return result;
    }
    return nil;
}

- (NSArray *)findViewsWithTag:(NSString *)subviewTag {
    NSMutableArray *result = [NSMutableArray array];
    if ([tags containsObject:subviewTag]) [result addObject:self.view];

    for (PGView *subview in subviews) {
        [result addObjectsFromArray:[subview findViewsWithTag:subviewTag]];
    }
    
    return result;
}

#pragma mark - PGViewAdapter methods

+ (NSString *)name {
    return @"view";
}

+ (NSDictionary *)properties {
    return [NSDictionary dictionaryWithObjectsAndKeys:
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
            nil];
}

+ (Class)underlyingClass {
    return [UIView class];
}

- (void)setValue:(NSString *)string forVirtualProperty:(NSString *)propertyName {
    // No virtual properties
}


@end