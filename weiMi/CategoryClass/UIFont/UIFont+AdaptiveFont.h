//
//  UIFont+AdaptiveFont.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (AdaptiveFont)

+ (void)hook;
+ (UIFont *)hook_fontWithName:(NSString *)fontName size:(CGFloat)fontSize;

@end
