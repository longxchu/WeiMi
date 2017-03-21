//
//  WeiMiMyChartListRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/26.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyChartListRequest.h"

@implementation WeiMiMyChartListRequest
{
    NSString *_phone;
    NSInteger _isAble;//1为购物产品/2为免费体验产品
}

- (id)initWithMemberId:(NSString *)memberId isAble:(NSInteger)isAble
{
    self = [super init];
    if (self) {
        _phone = memberId;
        _isAble = isAble;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Shop_list.html";
}


- (id)requestArgument {
    return @{
             @"memberId": _phone,
             @"isAble": [NSNumber numberWithInteger:_isAble],
             };
}

@end
