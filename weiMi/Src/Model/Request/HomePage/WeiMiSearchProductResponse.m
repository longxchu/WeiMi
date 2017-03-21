//
//  WeiMiSearchProductResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2017/1/8.
//  Copyright © 2017年 madaoCN. All rights reserved.
//

#import "WeiMiSearchProductResponse.h"

@implementation WeiMiSearchProductResponse

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
        WeiMiHPProductListDTO *dto = [[WeiMiHPProductListDTO alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];
    }
}

@end
