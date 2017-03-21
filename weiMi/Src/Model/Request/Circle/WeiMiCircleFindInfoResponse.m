//
//  WeiMiCircleFindInfoResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/12/1.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleFindInfoResponse.h"

@implementation WeiMiCircleFindInfoResponse

- (instancetype)init
{
    if (self = [super init]) {
//        _dataArr = [NSMutableArray new];
    }
    return self;
}

- (void)parseResponse:(NSDictionary *)dic
{
//    for (NSDictionary *di in EncodeArrayFromDic(dic, @"result")) {
//        [_dataArr addObject:dto];
//    }
    NSDictionary *di = EncodeDicFromDic(dic, @"result");
    _dto = [[WeiMiHotCommandDTO alloc] init];
    [_dto encodeFromDictionary:di];
    
}
@end
