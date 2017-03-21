//
//  WeiMiComponentRegister.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiComponentRegister.h"

@implementation WeiMiComponentRegister

+ (NSDictionary *)mineDic
{
    return [WeiMiComponentRegister readPlistWithPlistName:@"MineList"];
}

+ (NSDictionary *)homeDic
{
    return [WeiMiComponentRegister readPlistWithPlistName:@"HomeList"];
}

+ (NSDictionary *)communityDic
{
    return [WeiMiComponentRegister readPlistWithPlistName:@"CommunityList"];
}

+ (NSDictionary *)readPlistWithPlistName:(NSString *)plist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    if (plistPath) {
       return [NSDictionary dictionaryWithContentsOfFile:plistPath];
    }
    return @{};
}

@end
