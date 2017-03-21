//
//  WeiMiExchangeCouponRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/30.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiExchangeCouponRequest.h"

@implementation WeiMiExchangeCouponRequest
{
    NSString *_strCode;
    NSString *_memberId;
}

- (id)initWithMemberId:(NSString *)memberId strCode:(NSString *)strCode
{
    self = [super init];
    if (self) {
        _memberId = memberId;
        _strCode = strCode;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Vs_huan.html";
}


- (id)requestArgument {
    return @{
             @"memberId": _memberId,
             @"strCode": _strCode,
             };
}
@end
