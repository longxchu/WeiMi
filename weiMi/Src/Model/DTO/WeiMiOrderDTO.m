//
//  WeiMiOrderDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiOrderDTO.h"

@implementation WeiMiOrderDTO

- (instancetype)init
{
    if (self = [super init]) {
        self.tradeStatus = 0;
        self.imgURL = TEST_IMAGE_URL;
        self.title = @"[买1送六][包邮]害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花";
        self.subTitle = @"规格:白色睡裙M码";
        self.price = 99.01;
        self.offPrice = 15.20;
        self.transportFee = 0.00f;
        self.buyNum = 3;
    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    
}


@end
