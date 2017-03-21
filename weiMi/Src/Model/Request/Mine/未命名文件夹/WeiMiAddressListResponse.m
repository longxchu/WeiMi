//
//  WeiMiAddressListResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiAddressListResponse.h"

@implementation WeiMiAddressListResponse


- (instancetype)init
{
    if (self = [super init]) {
        _dataArr = [NSMutableArray new];
    }
    return self;
}

-(void)parseResponse:(NSDictionary *)dic
{
    for (NSDictionary *di in EncodeArrayFromDic(dic, @"result")) {
        WeiMiRecAddDTO *dto = [[WeiMiRecAddDTO alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];
    }
}
@end
