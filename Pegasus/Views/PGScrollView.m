//
//  PGScrollView.m
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

#import "PGScrollView.h"

@implementation PGScrollView

+ (UIView *)internalViewWithAttributes:(NSDictionary *)attributes {
    return [[UIScrollView alloc] init];
}

+ (NSString *)name {
    return @"scrollview";
}

+ (NSDictionary *)properties {
    
    NSMutableDictionary *properties =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"CGPoint", @"contentOffset", 
                                      @"CGSize", @"contentSize",
                                      @"UIEdgeInsets", @"contentInset", 
                                      @"BOOL", @"scrollEnabled",
                                      @"BOOL", @"directionalLockEnabled", 
                                      @"BOOL", @"scrollsToTop",
                                      @"BOOL", @"pagingEnabled", 
                                      @"BOOL", @"bounces",
                                      @"BOOL", @"alwaysBounceVertical", 
                                      @"BOOL", @"alwaysBounceHorizontal",
                                      @"BOOL", @"canCancelContentTouches",
                                      @"BOOL", @"delaysContentTouches",
                                      @"float", @"decelerationRate",
                                      @"UIScrollViewIndicatorStyle", @"indicatorStyle",
                                      @"UIEdgeInsets", @"scrollIndicatorInsets",
                                      @"BOOL", @"showsHorizontalScrollIndicator",
                                      @"BOOL", @"showsVerticalScrollIndicator",
                                      @"float", @"zoomScale",
                                      @"float", @"maximumZoomScale",
                                      @"float", @"minimumZoomScale",
                                      @"BOOL", @"bouncesZoom",
                                      nil];
    

    [properties addEntriesFromDictionary:[PGView properties]];
    
    return properties;
}

@end