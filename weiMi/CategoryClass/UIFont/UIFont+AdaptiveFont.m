//
//  UIFont+AdaptiveFont.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "UIFont+AdaptiveFont.h"
#import <objc/runtime.h>

void bd_exchangeInstanceMethod(Class aClass, SEL oldSEL, SEL newSEL)
{
    Method oldMethod = class_getInstanceMethod(aClass, oldSEL);
    assert(oldMethod);
    Method newMethod = class_getInstanceMethod(aClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
}

void bd_exchageClassMethod(Class aClass, SEL oldSEL, SEL newSEL)
{
    Method oldClsMethod = class_getClassMethod(aClass, oldSEL);
    assert(oldClsMethod);
    Method newClsMethod = class_getClassMethod(aClass, newSEL);
    assert(newClsMethod);
    method_exchangeImplementations(oldClsMethod, newClsMethod);
}

@implementation UIFont (AdaptiveFont)

+ (void)hook
{
    bd_exchageClassMethod([UIFont class], @selector(fontWithName:size:), @selector(hook_fontWithName:size:));
    bd_exchageClassMethod([UIFont class], @selector(systemFontOfSize:), @selector(hook_systemFontOfSize:));
}

+ (UIFont *)hook_systemFontOfSize:(CGFloat)fontSize
{
    NSLog(@"before : %.1f", fontSize);
    CGFloat scale = ([UIScreen mainScreen].bounds.size.width / 375);
    NSLog(@"scale : %f", scale);
    UIFont *font = [self hook_systemFontOfSize:GetAdaapterFontSize(fontSize)];
    NSLog(@"after : %.1f", [font pointSize]);
    printf("<--------------------->\n");
    return font;
}

+ (UIFont *)hook_fontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
    NSLog(@"before : %.1f", fontSize);
    CGFloat scale = ([UIScreen mainScreen].bounds.size.width / 375);
    NSLog(@"scale : %f", scale);
    UIFont *font = [self hook_fontWithName:fontName size:GetAdaapterFontSize(fontSize)];
    NSLog(@"after : %.1f", [font pointSize]);
    printf("<--------------------->\n");
    return font;
}

@end
