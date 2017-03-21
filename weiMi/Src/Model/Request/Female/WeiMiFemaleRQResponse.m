//
//  WeiMiFemaleRQResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiFemaleRQResponse.h"

@implementation WeiMiFemaleRQResponse


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
