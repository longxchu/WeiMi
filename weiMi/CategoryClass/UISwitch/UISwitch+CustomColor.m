//
//  UISwitch+CustomColor.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "UISwitch+CustomColor.h"

@implementation UISwitch (CustomColor)

+ (instancetype)defaultSwitch
{
    UISwitch *defaultSwitch = [[UISwitch alloc] init];
    [defaultSwitch setOn:NO];
    defaultSwitch.onTintColor = HEX_RGB(BASE_COLOR_HEX);
    return defaultSwitch;
}


@end
