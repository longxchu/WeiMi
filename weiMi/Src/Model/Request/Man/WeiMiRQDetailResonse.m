//
//  WeiMiRQDetailResonse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/15.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRQDetailResonse.h"

@implementation WeiMiRQDetailResonse

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
        WeiMiMaleFemaleRQDTO *dto = [[WeiMiMaleFemaleRQDTO alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];
    }
}

@end
