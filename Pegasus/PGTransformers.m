//
//  PGTransformers.m
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

#import "PGTransformers.h"

@implementation PGTransformers

+ (SEL)transformerForType:(NSString *)type {
    // Primitives:
    if ([type isEqualToString:@"int"]) return @selector(intWithString:);
    if ([type isEqualToString:@"double"]) return @selector(doubleWithString:);
    if ([type isEqualToString:@"float"]) return @selector(floatWithString:);
    if ([type isEqualToString:@"BOOL"]) return @selector(boolWithString:);
    
    // Structs:
    // if ([type isEqualToString:@"CGRect"]) return @selector(rectWithString:);
    // if ([type isEqualToString:@"CGSize"]) return @selector(sizeWithString:);
    // if ([type isEqualToString:@"CGPoint"]) return @selector(pointWithString:);
    if ([type isEqualToString:@"CGAffineTransform"]) return @selector(affineTransformWithString:);
    if ([type isEqualToString:@"UIEdgeInsets"]) return @selector(edgeInsetsWithString:);
    
    // Enums:
    if ([type isEqualToString:@"UITextAlignment"]) return @selector(textAlignmentWithString:);
    if ([type isEqualToString:@"UITextBorderStyle"]) return @selector(textBorderStyleWithString:);
    if ([type isEqualToString:@"UIViewAutoresizing"]) return @selector(viewAutoresizingWithString:);
    if ([type isEqualToString:@"UIViewContentMode"]) return @selector(contentModeWithString:);
    if ([type isEqualToString:@"UILineBreakMode"]) return @selector(lineBreakModeWithString:);
    if ([type isEqualToString:@"UITextFieldViewMode"]) return @selector(textFieldViewModeWithString:);
    if ([type isEqualToString:@"UIScrollViewIndicatorStyle"]) return @selector(scrollViewIndicatorStyleWithString:);
    if ([type isEqualToString:@"UIProgressViewStyle"]) return @selector(progressViewStyleWithString:);
    // if ([type isEqualToString:@"UITableViewStyle"]) return @selector(tableViewStyleWithString:);
    if ([type isEqualToString:@"UITableViewCellSeparatorStyle"]) return @selector(tableViewCellSeparatorStyleWithString:);
    // if ([type isEqualToString:@"UIButtonType"]) return @selector(buttonTypeWithString:);
    if ([type isEqualToString:@"UIBarButtonItemStyle"]) return @selector(barButtonItemStyleWithString:);
    //if ([type isEqualToString:@"UIBarButtonSystemItem"]) return @selector(barButtonSystemItemWithString:);
    
    // Objects:
    if ([type isEqualToString:@"NSString"]) return @selector(stringWithString:);
    if ([type isEqualToString:@"UIColor"]) return @selector(colorWithString:);
    if ([type isEqualToString:@"UIImage"]) return @selector(imageWithString:);
    if ([type isEqualToString:@"UIFont"]) return @selector(fontWithString:);
    
    return NULL;
}

#pragma mark - Translators (Primitives)

+ (int)intWithString:(NSString *)string {
    return string.intValue;
}

+ (double)doubleWithString:(NSString *)string {
    return string.doubleValue;
}

+ (float)floatWithString:(NSString *)string {
    return string.floatValue;
}

+ (BOOL)boolWithString:(NSString *)string {
    if ([string isEqualToString:@"yes"] || [string isEqualToString:@"true"]) return YES;
    return NO;
}

#pragma mark - Translators (Structs)

+ (CGRect)rectWithString:(NSString *)string withParentRect:(CGRect)parentRect {
    if ([string isEqualToString:@"fill_parent"] || [string isEqualToString:@"match_parent"]) return parentRect;
    
    PGTuple *tuple = [[PGTuple alloc] initWithString:string];
    
    PGTuple *originTuple = [tuple objectAtIndex:0];
    PGTuple *sizeTuple = [tuple objectAtIndex:1];

    CGPoint origin = [PGTransformers pointWithString:[originTuple description] withParentSize:parentRect.size];
    CGSize size = [PGTransformers sizeWithString:[sizeTuple description] withParentSize:parentRect.size];
    
    CGRect frame;
    frame.origin = origin;
    frame.size = size;
    
    return frame;
}

+ (CGSize)sizeWithString:(NSString *)string withParentSize:(CGSize)parentSize {
    if ([string isEqualToString:@"fill_parent"] || [string isEqualToString:@"match_parent"]) return parentSize;
    
    CGSize size;

    PGTuple *tuple = [[PGTuple alloc] initWithString:string];
    
    NSString *wStr = [tuple objectAtIndex:0];
    if ([PGTransformers numericTypeOfString:wStr] == PGNumericTypeAbsolute) size.width = [wStr floatValue];
    else size.width = [PGTransformers percentageStrToFloat:wStr] * parentSize.width;
    
    NSString *hStr = [tuple objectAtIndex:1];
    if ([PGTransformers numericTypeOfString:hStr] == PGNumericTypeAbsolute) size.height = [hStr floatValue];
    else size.height = [PGTransformers percentageStrToFloat:hStr] * parentSize.height;

    return size;
}

+ (CGPoint)pointWithString:(NSString *)string withParentSize:(CGSize)parentSize {
    if ([string isEqualToString:@"origin"]) return CGPointZero;
        
    CGPoint point;
    
    PGTuple *tuple = [[PGTuple alloc] initWithString:string];
    
    NSString *xStr = [tuple objectAtIndex:0];
    if ([PGTransformers numericTypeOfString:xStr] == PGNumericTypeAbsolute) point.x = [xStr floatValue];
    else point.x = [PGTransformers percentageStrToFloat:xStr] * parentSize.width;

    NSString *yStr = [tuple objectAtIndex:1];
    if ([PGTransformers numericTypeOfString:yStr] == PGNumericTypeAbsolute) point.y = [yStr floatValue];
    else point.y = [PGTransformers percentageStrToFloat:yStr] * parentSize.height;
    
    return point;
}

+ (CGFloat)floatWithString:(NSString *)string withParentFloat:(CGFloat)parentFloat {
    if ([string isEqualToString:@"fill_parent"] || [string isEqualToString:@"match_parent"]) return parentFloat;
    if ([PGTransformers numericTypeOfString:string] == PGNumericTypeAbsolute) return [string floatValue];
    return [PGTransformers percentageStrToFloat:string] * parentFloat;
}

+ (CGAffineTransform)affineTransformWithString:(NSString *)string {
    return CGAffineTransformFromString(string);
}

+ (UIEdgeInsets)edgeInsetsWithString:(NSString *)string {
    return UIEdgeInsetsFromString(string);
}

#pragma mark - Translators (Enums)

+ (UITextAlignment)textAlignmentWithString:(NSString *)string {
    if ([string isEqualToString:@"left"] || [string isEqualToString:@"uitextalignmentleft"] || [string isEqualToString:@"nstextalignmentleft"]) return UITextAlignmentLeft;
    if ([string isEqualToString:@"right"] || [string isEqualToString:@"uitextalignmentright"] || [string isEqualToString:@"nstextalignmentleft"]) return UITextAlignmentRight;
    if ([string isEqualToString:@"center"] || [string isEqualToString:@"uitextalignmentcenter"] || [string isEqualToString:@"nstextalignmentleft"]) return UITextAlignmentCenter;
    return 0;
}

+ (UITextBorderStyle)textBorderStyleWithString:(NSString *)string {
    if ([string isEqualToString:@"bezel"] || [string isEqualToString:@"uitextborderstylebezel"]) return UITextBorderStyleBezel;
    if ([string isEqualToString:@"line"] || [string isEqualToString:@"uitextborderstyleline"]) return UITextBorderStyleLine;
    if ([string isEqualToString:@"none"] || [string isEqualToString:@"uitextborderstylenone"]) return UITextBorderStyleNone;
    if ([string isEqualToString:@"rounded_rect"] || [string isEqualToString:@"uitextborderstyleroundedrect"]) return UITextBorderStyleRoundedRect;
    return 0;
}

+ (UIViewAutoresizing)autoresizingWithString:(NSString *)string {
    UIViewAutoresizing mask = 0;
    NSArray *chunks = [string componentsSeparatedByString:@" "];
    for (NSString *chunk in chunks) {
        if ([chunk isEqualToString:@"none"] || [string isEqualToString:@"uiviewautoresizingnone"]) mask |= UIViewAutoresizingNone;
        if ([chunk isEqualToString:@"margin_left"] || [string isEqualToString:@"uiviewautoresizingflexibleleftmargin"]) mask |= UIViewAutoresizingFlexibleLeftMargin;
        if ([chunk isEqualToString:@"margin_right"] || [string isEqualToString:@"uiviewautoresizingflexiblerightmargin"]) mask |= UIViewAutoresizingFlexibleRightMargin;
        if ([chunk isEqualToString:@"margin_top"] || [string isEqualToString:@"uiviewautoresizingflexibletopmargin"]) mask |= UIViewAutoresizingFlexibleTopMargin;
        if ([chunk isEqualToString:@"margin_bottom"] || [string isEqualToString:@"uiviewautoresizingflexiblebottommargin"]) mask |= UIViewAutoresizingFlexibleBottomMargin;
        if ([chunk isEqualToString:@"width"] || [string isEqualToString:@"uiviewautoresizingflexiblewidth"]) mask |= UIViewAutoresizingFlexibleWidth;
        if ([chunk isEqualToString:@"height"] || [string isEqualToString:@"uiviewautoresizingflexibleheight"]) mask |= UIViewAutoresizingFlexibleHeight;
    }
    
    return mask;
}

+ (UIViewContentMode)contentModeWithString:(NSString *)string {
    if ([string isEqualToString:@"scale_to_fill"] || [string isEqualToString:@"uiviewcontentmodescaletofill"]) return UIViewContentModeScaleToFill;
    if ([string isEqualToString:@"scale_aspect_fit"] || [string isEqualToString:@"uiviewcontentmodescaleaspectfit"]) return UIViewContentModeScaleAspectFit;
    if ([string isEqualToString:@"scale_aspect_fill"] || [string isEqualToString:@"uiviewcontentmodescaleaspectfit"]) return UIViewContentModeScaleAspectFill;
    if ([string isEqualToString:@"redraw"] || [string isEqualToString:@"uiviewcontentmoderedraw"]) return UIViewContentModeRedraw;
    if ([string isEqualToString:@"center"] || [string isEqualToString:@"uiviewcontentmodecenter"]) return UIViewContentModeCenter;
    if ([string isEqualToString:@"top"] || [string isEqualToString:@"uiviewcontentmodetop"]) return UIViewContentModeTop;
    if ([string isEqualToString:@"bottom"] || [string isEqualToString:@"uiviewcontentmodebottom"]) return UIViewContentModeBottom;
    if ([string isEqualToString:@"left"] || [string isEqualToString:@"uiviewcontentmodeleft"]) return UIViewContentModeLeft;
    if ([string isEqualToString:@"right"] || [string isEqualToString:@"uiviewcontentmoderight"]) return UIViewContentModeRight;
    if ([string isEqualToString:@"top_left"] || [string isEqualToString:@"uiviewcontentmodetopleft"]) return UIViewContentModeTopLeft;
    if ([string isEqualToString:@"top_right"] || [string isEqualToString:@"uiviewcontentmodetopright"]) return UIViewContentModeTopRight;
    if ([string isEqualToString:@"bottom_left"] || [string isEqualToString:@"uiviewcontentmodebottomleft"]) return UIViewContentModeBottomLeft;
    if ([string isEqualToString:@"bottom_right"] || [string isEqualToString:@"uiviewcontentmodebottomright"]) return UIViewContentModeBottomRight;
    
    return 0;
}

+ (UILineBreakMode)lineBreakModeWithString:(NSString *)string {
    if ([string isEqualToString:@"word_wrap"] || [string isEqualToString:@"uilinebreakmodewordwrap"]) return UILineBreakModeWordWrap;
    if ([string isEqualToString:@"character_wrap"] || [string isEqualToString:@"uilinebreakmodecharacterwrap"]) return UILineBreakModeCharacterWrap;
    if ([string isEqualToString:@"clip"] || [string isEqualToString:@"uilinebreakmodeclip"]) return UILineBreakModeClip;
    if ([string isEqualToString:@"head_truncation"] || [string isEqualToString:@"uilinebreakmodeheadtruncation"]) return UILineBreakModeHeadTruncation;
    if ([string isEqualToString:@"tail_truncation"] || [string isEqualToString:@"uilinebreakmodetailtruncation"]) return UILineBreakModeTailTruncation;
    if ([string isEqualToString:@"middle_truncation"] || [string isEqualToString:@"uilinebreakmodemiddletruncation"]) return UILineBreakModeMiddleTruncation;
    return 0;
}

+ (UITextFieldViewMode)textFieldViewModeFromString:(NSString *)string {
    if ([string isEqualToString:@"always"] || [string isEqualToString:@"uitextfieldviewmodealways"]) return UITextFieldViewModeAlways;
    if ([string isEqualToString:@"never"] || [string isEqualToString:@"uitextfieldviewmodenever"]) return UITextFieldViewModeNever;
    if ([string isEqualToString:@"unless_editing"] || [string isEqualToString:@"uitextfieldviewmodeunlessediting"]) return UITextFieldViewModeUnlessEditing;
    if ([string isEqualToString:@"while_editing"] || [string isEqualToString:@"uitextfieldviewmodewhileediting"]) return UITextFieldViewModeWhileEditing;

    return 0;
}

+ (UIScrollViewIndicatorStyle)scrollViewIndicatorStyleWithString:(NSString *)string {
    if ([string isEqualToString:@"default"] || [string isEqualToString:@"uiscrollviewindicatorstyledefault"]) return UIScrollViewIndicatorStyleDefault;
    if ([string isEqualToString:@"black"] || [string isEqualToString:@"uiscrollviewindicatorstyleblack"]) return UIScrollViewIndicatorStyleBlack;
    if ([string isEqualToString:@"white"] || [string isEqualToString:@"uiscrollviewindicatorstylewhite"]) return UIScrollViewIndicatorStyleWhite;
    return 0;
}

+ (UIProgressViewStyle)progressViewStyleWithString:(NSString *)string {
    if ([string isEqualToString:@"default"] || [string isEqualToString:@"uiprogressviewstyledefault"]) return UIProgressViewStyleDefault;
    if ([string isEqualToString:@"bar"] || [string isEqualToString:@"uiprogressviewstylebar"]) return UIProgressViewStyleBar;
    return 0;
}

+ (UITableViewStyle)tableViewStyleWithString:(NSString *)string {
    if ([string isEqualToString:@"plain"] || [string isEqualToString:@"uitableviewstyleplain"]) return UITableViewStylePlain;
    if ([string isEqualToString:@"grouped"] || [string isEqualToString:@"uitableviewstylegrouped"]) return UITableViewStyleGrouped;
    return 0;
}

+ (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyleWithString:(NSString *)string {
    if ([string isEqualToString:@"none"] || [string isEqualToString:@"uitableviewcellseparatorstylenone"]) return UITableViewCellSeparatorStyleNone;
    if ([string isEqualToString:@"single_line"] || [string isEqualToString:@"uitableviewcellseparatorstylesingleline"]) return UITableViewCellSeparatorStyleSingleLine;
    if ([string isEqualToString:@"single_line_etched"] || [string isEqualToString:@"uitableviewcellseparatorstylesinglelineetched"]) return UITableViewCellSeparatorStyleSingleLineEtched;
    return 0;
}

+ (UIButtonType)buttonTypeWithString:(NSString *)string {
    if ([string isEqualToString:@"custom"] || [string isEqualToString:@"uibuttontypecustom"]) return UIButtonTypeCustom;
    if ([string isEqualToString:@"rounded_rect"] || [string isEqualToString:@"uibuttontyperoundedrect"]) return UIButtonTypeRoundedRect;
    if ([string isEqualToString:@"detail_disclosure"] || [string isEqualToString:@"uibuttontypedetaildisclosure"]) return UIButtonTypeDetailDisclosure;
    if ([string isEqualToString:@"info_light"] || [string isEqualToString:@"uibuttontypeinfolight"]) return UIButtonTypeInfoLight;
    if ([string isEqualToString:@"info_dark"] || [string isEqualToString:@"uibuttontypeinfodark"]) return UIButtonTypeInfoDark;
    if ([string isEqualToString:@"contact_add"] || [string isEqualToString:@"uibuttontypecontactadd"]) return UIButtonTypeContactAdd;
    return 0;
}

+ (UIBarButtonItemStyle)barButtonItemStyleWithString:(NSString *)string {
    if ([string isEqualToString:@"plain"] || [string isEqualToString:@"uibarbuttonitemstyleplain"]) return UIBarButtonItemStylePlain;
    if ([string isEqualToString:@"bordered"] || [string isEqualToString:@"uibarbuttonitemstylebordered"]) return UIBarButtonItemStyleBordered;
    if ([string isEqualToString:@"done"] || [string isEqualToString:@"uibarbuttonitemstyledone"]) return UIBarButtonItemStyleDone;
    return 0;
}

+ (UIBarButtonSystemItem)barButtonSystemItemWithString:(NSString *)string {
    if ([string isEqualToString:@"done"] || [string isEqualToString:@"uibarbuttonsystemitemdone"]) return UIBarButtonSystemItemDone;
    if ([string isEqualToString:@"cancel"] || [string isEqualToString:@"uibarbuttonsystemitemcancel"]) return UIBarButtonSystemItemCancel;
    if ([string isEqualToString:@"edit"] || [string isEqualToString:@"uibarbuttonsystemitemedit"]) return UIBarButtonSystemItemEdit;
    if ([string isEqualToString:@"save"] || [string isEqualToString:@"uibarbuttonsystemitemsave"]) return UIBarButtonSystemItemSave;
    if ([string isEqualToString:@"add"] || [string isEqualToString:@"uibarbuttonsystemadd"]) return UIBarButtonSystemItemAdd;
    if ([string isEqualToString:@"flexible_space"] || [string isEqualToString:@"uibarbuttonsystemitemflexiblespace"]) return UIBarButtonSystemItemFlexibleSpace;
    if ([string isEqualToString:@"fixed_space"] || [string isEqualToString:@"uibarbuttonsystemitemfixedspace"]) return UIBarButtonSystemItemFixedSpace;
    if ([string isEqualToString:@"compose"] || [string isEqualToString:@"uibarbuttonsystemitemcompose"]) return UIBarButtonSystemItemCompose;
    if ([string isEqualToString:@"reply"] || [string isEqualToString:@"uibarbuttonsystemitemreply"]) return UIBarButtonSystemItemReply;
    if ([string isEqualToString:@"action"] || [string isEqualToString:@"uibarbuttonsystemitemaction"]) return UIBarButtonSystemItemAction;
    if ([string isEqualToString:@"organize"] || [string isEqualToString:@"uibarbuttonsystemitemorganize"]) return UIBarButtonSystemItemOrganize;
    if ([string isEqualToString:@"bookmarks"] || [string isEqualToString:@"uibarbuttonsystemitembookmarks"]) return UIBarButtonSystemItemBookmarks;
    if ([string isEqualToString:@"search"] || [string isEqualToString:@"uibarbuttonsystemitemsearch"]) return UIBarButtonSystemItemSearch;
    if ([string isEqualToString:@"refresh"] || [string isEqualToString:@"uibarbuttonsystemitemrefresh"]) return UIBarButtonSystemItemRefresh;
    if ([string isEqualToString:@"stop"] || [string isEqualToString:@"uibarbuttonsystemitemstop"]) return UIBarButtonSystemItemStop;
    if ([string isEqualToString:@"camera"] || [string isEqualToString:@"uibarbuttonsystemitemcamera"]) return UIBarButtonSystemItemCamera;
    if ([string isEqualToString:@"trash"] || [string isEqualToString:@"uibarbuttonsystemitemtrash"]) return UIBarButtonSystemItemTrash;
    if ([string isEqualToString:@"play"] || [string isEqualToString:@"uibarbuttonsystemitemplay"]) return UIBarButtonSystemItemPlay;
    if ([string isEqualToString:@"pause"] || [string isEqualToString:@"uibarbuttonsystempause"]) return UIBarButtonSystemItemPause;
    if ([string isEqualToString:@"rewind"] || [string isEqualToString:@"uibarbuttonsystemrewind"]) return UIBarButtonSystemItemRewind;
    if ([string isEqualToString:@"fast_forward"] || [string isEqualToString:@"uibarbuttonsystemfastforward"]) return UIBarButtonSystemItemFastForward;
    if ([string isEqualToString:@"undo"] || [string isEqualToString:@"uibarbuttonsystemitemundo"]) return UIBarButtonSystemItemUndo;
    if ([string isEqualToString:@"redo"] || [string isEqualToString:@"uibarbuttonsystemitemredo"]) return UIBarButtonSystemItemRedo;
    if ([string isEqualToString:@"page_curl"] || [string isEqualToString:@"uibarbuttonsystemitempagecurl"]) return UIBarButtonSystemItemPageCurl;
    return 0;
}

#pragma mark - Translators (Objects)

+ (NSString *)stringWithString:(NSString *)string {
    return string;
}

+ (UIColor *)colorWithString:(NSString *)string {
    // Hex color:
    if ([[string substringToIndex:1] isEqualToString:@"#"]) return [UIColor colorWithHexString:string];
    
    // Preset colors:
    if ([string isEqualToString:@"black"]) return [UIColor blackColor];
    if ([string isEqualToString:@"dark_gray"]) return [UIColor darkGrayColor];
    if ([string isEqualToString:@"light_gray"]) return [UIColor lightGrayColor];
    if ([string isEqualToString:@"white"]) return [UIColor whiteColor];
    if ([string isEqualToString:@"gray"]) return [UIColor grayColor];
    if ([string isEqualToString:@"red"]) return [UIColor redColor];
    if ([string isEqualToString:@"green"]) return [UIColor greenColor];
    if ([string isEqualToString:@"blue"]) return [UIColor blueColor];
    if ([string isEqualToString:@"cyan"]) return [UIColor cyanColor];    
    if ([string isEqualToString:@"yellow"]) return [UIColor yellowColor];
    if ([string isEqualToString:@"magenta"]) return [UIColor magentaColor];
    if ([string isEqualToString:@"orange"]) return [UIColor orangeColor];
    if ([string isEqualToString:@"purple"]) return [UIColor purpleColor];
    if ([string isEqualToString:@"brown"]) return [UIColor brownColor];
    if ([string isEqualToString:@"clear"]) return [UIColor clearColor];
    return nil;
}

+ (UIImage *)imageWithString:(NSString *)string {
    return [UIImage imageNamed:string];
}

+ (UIFont *)fontWithString:(NSString *)string {
    NSArray *components = [string componentsSeparatedByString:@" "];
    NSString *name = [components objectAtIndex:0];
    float size = [[components objectAtIndex:1] floatValue];
    
    if ([name isEqualToString:@"system"]) return [UIFont systemFontOfSize:size];
    if ([name isEqualToString:@"system_bold"]) return [UIFont boldSystemFontOfSize:size];
    if ([name isEqualToString:@"system_italic"]) return [UIFont italicSystemFontOfSize:size];

    return [UIFont fontWithName:name size:size];
}

#pragma mark - Helper methods

+ (PGNumericType)numericTypeOfString:(NSString *)string {
    if ([string rangeOfString:@"%"].location != NSNotFound) return PGNumericTypeRelative;
    return PGNumericTypeAbsolute;
}

+ (float)percentageStrToFloat:(NSString *)string {
    NSCharacterSet *percentageSet = [NSCharacterSet characterSetWithCharactersInString:@"%"];
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:percentageSet];
    return [trimmedString floatValue] / 100.0;
}

@end
