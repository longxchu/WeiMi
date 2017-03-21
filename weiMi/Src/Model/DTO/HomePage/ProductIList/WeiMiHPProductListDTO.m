//
//  WeiMiHPProductListDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHPProductListDTO.h"

@implementation WeiMiHPProductListDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.proTypeId = EncodeStringFromDic(dic, @"proTypeId");
    self.vipprice = EncodeStringFromDic(dic, @"vipprice");
    self.remark = EncodeStringFromDic(dic, @"remark");
    self.cishu = EncodeStringFromDic(dic, @"cishu");
    self.menuId = EncodeStringFromDic(dic, @"menuId");
    
    self.number = EncodeStringFromDic(dic, @"number");//库存
    self.property = EncodeStringFromDic(dic, @"property");
    self.faceImgPath = EncodeStringFromDic(dic, @"faceImgPath");
    self.endTime = EncodeStringFromDic(dic, @"endTime");
    self.brandName = EncodeStringFromDic(dic, @"brandName");
    self.brandId = EncodeStringFromDic(dic, @"brandId");
    
    self.salesVolume = EncodeStringFromDic(dic, @"salesVolume");
    self.proTypeName = EncodeStringFromDic(dic, @"proTypeName");
    self.productId = EncodeStringFromDic(dic, @"productId");
    self.zengpin = EncodeStringFromDic(dic, @"zengpin");
    self.startTime = EncodeStringFromDic(dic, @"startTime");
    
    self.price = EncodeStringFromDic(dic, @"price");
    self.imgfiles = EncodeStringFromDic(dic, @"imgfiles");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.productName = EncodeStringFromDic(dic, @"productName");
    self.menuName = EncodeStringFromDic(dic, @"menuName");
}


@end
