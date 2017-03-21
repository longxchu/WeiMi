//
//  WeiMiHPBrandResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHPBrandResponse.h"

@implementation WeiMiHPBrandResponse


- (instancetype)init
{
    if (self = [super init]) {
        _dataArr = [NSMutableArray new];
    }
    return self;
}

- (void)parseResponse:(NSDictionary *)dic
{
    for (NSDictionary *di in EncodeArrayFromDic(dic, @"result")) {
        WeiMiHPBrandDTO *dto = [[WeiMiHPBrandDTO alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];
    }
}

@end
