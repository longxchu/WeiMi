//
//  WeiMiMyCouponListResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/30.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyCouponListResponse.h"

@implementation WeiMiMyCouponListResponse

- (instancetype)init
{
    if (self = [super init]) {
        _dataArr = [NSMutableArray new];
    }
    return self;
}

-(void)parseResponse:(NSDictionary *)dic
{
    for (NSDictionary *di in EncodeArrayFromDic(dic, @"result")) {

        WeiMiPrivilegeDTO *dto = [[WeiMiPrivilegeDTO alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];

    }
}

@end
