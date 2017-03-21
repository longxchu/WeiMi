//
//  WeiMiTryoutListDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTryoutListDTO.h"

@implementation WeiMiTryoutListDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.applyId = EncodeStringFromDic(dic, @"applyId");
    self.applyTitle = EncodeStringFromDic(dic, @"applyTitle");
    self.applyImg = EncodeStringFromDic(dic, @"applyImg");
    self.applyPrice = EncodeStringFromDic(dic, @"applyPrice");
    self.applyNumber = EncodeStringFromDic(dic, @"applyNumber").integerValue;
    
    self.applyBrand = EncodeStringFromDic(dic, @"applyBrand");
    self.applyName = EncodeStringFromDic(dic, @"applyName");
    self.applyCz = EncodeStringFromDic(dic, @"applyCz");
    self.applyColor = EncodeStringFromDic(dic, @"applyColor");
    self.applyContent = EncodeStringFromDic(dic, @"applyContent");
    
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.numPerson = EncodeStringFromDic(dic, @"numPerson").integerValue;
    self.endTime = EncodeStringFromDic(dic, @"endTime");
}

@end
