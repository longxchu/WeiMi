//
//  WeiMiTryoutListResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTryoutListResponse.h"

@implementation WeiMiTryoutListResponse

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
        WeiMiTryoutListDTO *dto = [[WeiMiTryoutListDTO alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];
    }

}

@end
