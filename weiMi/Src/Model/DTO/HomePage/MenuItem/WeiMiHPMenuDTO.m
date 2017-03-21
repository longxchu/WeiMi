//
//  WeiMiHPMenuDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHPMenuDTO.h"

@implementation WeiMiHPMenuDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.menuName = EncodeStringFromDic(dic, @"menuName");
    self.menuId = EncodeStringFromDic(dic, @"menuId");
    self.menuImgPath = EncodeStringFromDic(dic, @"menuImgPath");
    self.isAble = EncodeNumberFromDic(dic, @"isAble").integerValue;
    self.menuSort = EncodeNumberFromDic(dic, @"menuSort").integerValue;
    
}

@end
