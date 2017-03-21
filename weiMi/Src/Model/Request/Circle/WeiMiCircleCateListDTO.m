//
//  WeiMiCircleCateListDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/26.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleCateListDTO.h"

@implementation WeiMiCircleCateListDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.typeName = EncodeStringFromDic(dic, @"typeName");
    self.createTime = EncodeStringFromDic(dic, @"createTime");
    self.ringId = EncodeStringFromDic(dic, @"ringId");
    self.ringTitle = EncodeStringFromDic(dic, @"ringTitle");
    
    self.dzscription = EncodeStringFromDic(dic, @"description");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    self.ringIcon = EncodeStringFromDic(dic, @"ringIcon");
    
    self.memberName = EncodeStringFromDic(dic, @"memberName");
    self.typeId = EncodeStringFromDic(dic, @"typeId");
    self.isShou = EncodeStringFromDic(dic, @"isShou");
    
}

@end
