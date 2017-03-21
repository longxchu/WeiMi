//
//  WeiMiHPBrandDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHPBrandDTO.h"

@implementation WeiMiHPBrandDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.brandId = EncodeStringFromDic(dic, @"brandId");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.brandName = EncodeStringFromDic(dic, @"brandName");
    self.brandImgPath = EncodeStringFromDic(dic, @"brandImgPath");
}

@end
