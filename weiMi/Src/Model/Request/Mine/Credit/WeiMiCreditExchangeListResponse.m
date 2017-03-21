//
//  WeiMiCreditExchangeListResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/12/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCreditExchangeListResponse.h"

@implementation WeiMiCreditExchangeListResponse

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
        WeiMiMyCreditDTO *dto = [[WeiMiMyCreditDTO alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];
    }
}

@end
