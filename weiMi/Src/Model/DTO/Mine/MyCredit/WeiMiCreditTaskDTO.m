//
//  WeiMiCreditTaskDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCreditTaskDTO.h"

@implementation WeiMiCreditTaskDTO

-(void)encodeFromDictionary:(NSDictionary *)dic
{
    self.baseNumber = EncodeStringFromDic(dic, @"baseNumber");
    self.baseType = EncodeStringFromDic(dic, @"baseType");
    self.baseName = EncodeStringFromDic(dic, @"baseName");
    self.baseValue = EncodeStringFromDic(dic, @"baseValue");
    self.baseId = EncodeStringFromDic(dic, @"baseId");

}

@end
