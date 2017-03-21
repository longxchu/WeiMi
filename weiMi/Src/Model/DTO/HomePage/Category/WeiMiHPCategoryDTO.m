//
//  WeiMiHPCategoryDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHPCategoryDTO.h"

@implementation WeiMiHPCategoryDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.proTypeId = EncodeStringFromDic(dic, @"proTypeId");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.proTypeName = EncodeStringFromDic(dic, @"proTypeName");
}
@end
