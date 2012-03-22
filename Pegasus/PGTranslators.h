//
//  PGTranslators.h
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

#import <Foundation/Foundation.h>

typedef enum {
    PGNumericTypeAbsolute,
    PGNumericTypeRelative
} PGNumericType;

@interface PGTranslators : NSObject

+ (SEL)translatorForType:(NSString *)type;

#pragma mark - Translators (Primitives)
+ (int)intWithString:(NSString *)string;
+ (double)doubleWithString:(NSString *)string;
+ (float)floatWithString:(NSString *)string;
+ (BOOL)boolWithString:(NSString *)string;

#pragma mark - Translators (Structs)
+ (CGRect)rectWithString:(NSString *)string;
+ (CGSize)sizeWithString:(NSString *)string;
+ (CGPoint)pointWithString:(NSString *)string;
+ (CGAffineTransform)affineTransformWithString:(NSString *)string;
+ (UIEdgeInsets)edgeInsetsWithString:(NSString *)string;

#pragma mark - Translators (Enums)
+ (UITextAlignment)textAlignmentWithString:(NSString *)string;
+ (UITextBorderStyle)textBorderStyleWithString:(NSString *)string;
+ (UIViewAutoresizing)autoresizingWithString:(NSString *)string;
+ (UIViewContentMode)contentModeWithString:(NSString *)string;
+ (UILineBreakMode)lineBreakModeWithString:(NSString *)string;
+ (UITextFieldViewMode)textFieldViewModeFromString:(NSString *)string;
+ (UIScrollViewIndicatorStyle)scrollViewIndicatorStyleWithString:(NSString *)string;
+ (UIProgressViewStyle)progressViewStyleWithString:(NSString *)string;
+ (UITableViewStyle)tableViewStyleWithString:(NSString *)string;
+ (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyleWithString:(NSString *)string;
+ (UIButtonType)buttonTypeWithString:(NSString *)string;
+ (UIBarButtonItemStyle)barButtonItemStyleWithString:(NSString *)string;
+ (UIBarButtonSystemItem)barButtonSystemItemWithString:(NSString *)string;
+ (UITabBarSystemItem)tabBarSystemItemWithString:(NSString *)string;

#pragma mark - Translators (Objects)
+ (NSString *)stringWithString:(NSString *)string;
+ (UIColor *)colorWithString:(NSString *)string;
+ (UIImage *)imageWithString:(NSString *)string;
+ (UIFont *)fontWithString:(NSString *)string;

#pragma mark - Helper methods
+ (PGNumericType)numericTypeOfString:(NSString *)string;
+ (float)percentageStrToFloat:(NSString *)string;

@end
