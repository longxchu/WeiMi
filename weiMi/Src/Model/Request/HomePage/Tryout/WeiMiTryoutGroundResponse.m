//
//  WeiMiTryoutGroundResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/31.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTryoutGroundResponse.h"

@implementation WeiMiTryoutGroundResponse

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
        WeiMiTryoutGroundDTO *dto = [[WeiMiTryoutGroundDTO alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];
    }
    
}

@end
