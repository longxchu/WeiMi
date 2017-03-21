//
//  WeiMiTryoutGroundDetailResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/31.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTryoutGroundDetailResponse.h"

@implementation WeiMiTryoutGroundDetailResponse

- (void)parseResponse:(NSDictionary *)dic
{
    NSDictionary *di = EncodeDicFromDic(dic, @"result");
    _dto = [[WeiMiTryoutGroundDetailDTO alloc] init];
    [_dto encodeFromDictionary:di];
}

@end
