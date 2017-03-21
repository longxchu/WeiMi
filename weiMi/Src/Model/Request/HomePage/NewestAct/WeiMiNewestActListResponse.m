//
//  WeiMiNewestActListResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/25.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiNewestActListResponse.h"

@implementation WeiMiNewestActListResponse


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
        WeiMiNewestActDTO *dto = [[WeiMiNewestActDTO alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];
    }
    
}

@end
