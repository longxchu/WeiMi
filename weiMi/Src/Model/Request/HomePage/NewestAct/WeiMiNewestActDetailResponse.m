//
//  WeiMiNewestActDetailResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiNewestActDetailResponse.h"

@implementation WeiMiNewestActDetailResponse

- (void)parseResponse:(NSDictionary *)dic
{
    NSDictionary *di = EncodeDicFromDic(dic, @"result");
    _dto = [[WeiMiNewestActDetailDTO alloc] init];
    [_dto encodeFromDictionary:di];
}

@end
