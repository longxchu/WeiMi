//
//  WeiMiPrivilegeDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPrivilegeDTO.h"
#import "DateUtil.h"

@implementation WeiMiPrivilegeDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.voucherTimeStart = EncodeStringFromDic(dic, @"voucherTimeStart");
    self.voucherStart = EncodeStringFromDic(dic, @"voucherStart");
    self.voucherEnd = EncodeStringFromDic(dic, @"voucherEnd");
    self.vouImg = EncodeStringFromDic(dic, @"vouImg");
    self.vouType = EncodeStringFromDic(dic, @"vouType");
    
    self.vouTitle = EncodeStringFromDic(dic, @"vouTitle");
    self.voucherTimeEnd = EncodeStringFromDic(dic, @"voucherTimeEnd");
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.vouPrice = EncodeStringFromDic(dic, @"vouPrice");
    self.voucherId = EncodeStringFromDic(dic, @"voucherId");
    
    self.timeOut = YES;
    if (self.voucherTimeEnd) {
        
        NSDate *date = [DateUtil getDateFromStringWithDefaultFormat:self.voucherTimeEnd];
        NSDate *currentDate = [NSDate date];
        double diff = [DateUtil timeDiff:DVM_SECOND beginTime:date endTime:currentDate];
        if (diff > 0.0000001) {//未截止
            self.timeOut = NO;
        }
    }
}

@end
