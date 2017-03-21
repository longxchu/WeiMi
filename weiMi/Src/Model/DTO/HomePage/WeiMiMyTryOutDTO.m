//
//  WeiMiMyTryOutDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyTryOutDTO.h"

@implementation WeiMiMyTryOutDTO

- (instancetype)init
{
    if (self = [super init]) {
        self.imgURL = TEST_IMAGE_URL;
        self.title = @"[买1送六][包邮]害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花";
        self.applyNum = 1024;
        self.deadDate = @"8月10日";
        self.status = @"申请中";
    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    
}

@end
