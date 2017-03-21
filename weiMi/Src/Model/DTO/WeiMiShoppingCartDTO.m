//
//  WeiMiShoppingCartDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/17.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiShoppingCartDTO.h"

@implementation WeiMiShoppingCartDTO

- (instancetype)init
{
    if (self = [super init]) {
//        self.imgURL = TEST_IMAGE_URL;
//        self.title = @"[买1送六][包邮]害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花";
//        self.subTitle = @"规格:白色睡裙M码";
//        self.price = 99.01;
    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.imgURL = WEIMI_IMAGEREMOTEURL(EncodeStringFromDic(dic, @"productImg"));
    self.title = EncodeStringFromDic(dic, @"productName");
    self.subTitle = EncodeStringFromDic(dic, @"property");
    self.price = EncodeNumberFromDic(dic, @"price").floatValue;
    self.number = EncodeNumberFromDic(dic, @"number").integerValue;

    self.shopId = EncodeStringFromDic(dic, @"shopId");
    self.productType = EncodeStringFromDic(dic, @"productType");
    self.productBrand = EncodeStringFromDic(dic, @"productBrand");
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    self.productId = EncodeStringFromDic(dic, @"productId");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.createTime = EncodeStringFromDic(dic, @"createTime");
}

@end
