//
//  WeiMiCircleCateDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/26.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleCateDTO.h"

@implementation WeiMiCircleCateDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.typeName = EncodeStringFromDic(dic, @"typeName");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.type = EncodeStringFromDic(dic, @"type");
    self.typeId = EncodeStringFromDic(dic, @"typeId");

}

@end
