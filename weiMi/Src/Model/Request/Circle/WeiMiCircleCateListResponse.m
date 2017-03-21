//
//  WeiMiCircleCateListResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/26.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleCateListResponse.h"

@implementation WeiMiCircleCateListResponse

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
        WeiMiCircleCateListDTO *dto = [[WeiMiCircleCateListDTO alloc] init];
        [dto encodeFromDictionary:di];
        if ([dto.isAble isEqualToString:@"1"]) {//isAble == 1 显示 否则隐藏
            [_dataArr addObject:dto];
        }
    }
}

@end
