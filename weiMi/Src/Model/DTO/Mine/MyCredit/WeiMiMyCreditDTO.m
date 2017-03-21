//
//  WeiMiMyCreditDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyCreditDTO.h"

@implementation WeiMiMyCreditDTO

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(void)encodeFromDictionary:(NSDictionary *)dic
{
    self.imgURL = WEIMI_IMAGEREMOTEURL(EncodeStringFromDic(dic, @"vouImg"));
    self.title = EncodeStringFromDic(dic, @"vouTitle");
    self.vouPrice = EncodeStringFromDic(dic, @"vouPrice");
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.vouType = EncodeStringFromDic(dic, @"vouType");
    
    self.voucherTimeStart = EncodeStringFromDic(dic, @"voucherTimeStart");
    self.voucherStart = EncodeStringFromDic(dic, @"voucherStart");
    self.voucherEnd = EncodeStringFromDic(dic, @"voucherEnd");
    self.voucherId = EncodeStringFromDic(dic, @"voucherId");
}

@end
