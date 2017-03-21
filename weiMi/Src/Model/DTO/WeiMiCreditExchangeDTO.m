//
//  WeiMiCreditExchangeDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCreditExchangeDTO.h"
#import "DateUtil.h"

@implementation WeiMiCreditExchangeDTO

- (instancetype)init
{
    if (self = [super init]) {
//        self.imgURL = TEST_IMAGE_URL;
//        self.title = @"[买1送六][包邮]害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花";
//        self.subTitle = @"290积分";
    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.imgURL = WEIMI_IMAGEREMOTEURL(EncodeStringFromDic(dic, @"vouImg"));
    self.title = EncodeStringFromDic(dic, @"vouName");
    self.vouPrice = EncodeStringFromDic(dic, @"vouPrice");
    self.vouId = EncodeStringFromDic(dic, @"vouId");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.vouType = EncodeStringFromDic(dic, @"vouType");
    
        self.vouTime = EncodeStringFromDic(dic, @"vouTime");
        self.vouStart = EncodeStringFromDic(dic, @"vouStart");
        self.vouEnd = EncodeStringFromDic(dic, @"vouEnd");
    
//    if (dto.endTime) {
//        NSDate *date = [DateUtil getDateFromStringWithDefaultFormat:dto.endTime];
//        NSDate *currentDate = [NSDate date];
//        double diff = [DateUtil timeDiff:DVM_SECOND beginTime:date endTime:currentDate];
//        if (diff > 0.0000001) {//未截止
//            isEnd = NO;
//        }
//    }
}

@end
