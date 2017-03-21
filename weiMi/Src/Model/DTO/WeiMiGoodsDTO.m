//
//  WeiMiGoodsDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiGoodsDTO.h"

@implementation WeiMiGoodsDTO

- (instancetype)init
{
    if (self = [super init]) {

    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.imageURL = EncodeStringFromDic(dic, @"faceImgPath");
    self.titleStr = EncodeStringFromDic(dic, @"productName");
    self.priceStr = EncodeStringFromDic(dic, @"price");
    
    self.productId = EncodeStringFromDic(dic, @"productId");
    self.collectId = EncodeStringFromDic(dic, @"collectId");
    self.menuId = EncodeStringFromDic(dic, @"menuId");
    self.brandId = EncodeStringFromDic(dic, @"brandId");
    self.proTypeId = EncodeStringFromDic(dic, @"proTypeId");
    self.salesVolume = EncodeStringFromDic(dic, @"salesVolume");
    self.number = EncodeStringFromDic(dic, @"number");
    self.property = EncodeStringFromDic(dic, @"property");
    self.remark = EncodeStringFromDic(dic, @"remark");
    self.remark = EncodeStringFromDic(dic, @"remark");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    
    self.isShow = EncodeStringFromDic(dic, @"isShow");
    self.imgfiles = EncodeStringFromDic(dic, @"imgfiles");
    self.startTime = EncodeStringFromDic(dic, @"startTime");
    self.endTime = EncodeStringFromDic(dic, @"endTime");
    self.cishu = EncodeStringFromDic(dic, @"cishu");
}

@end
