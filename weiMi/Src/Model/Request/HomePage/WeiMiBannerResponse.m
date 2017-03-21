//
//  WeiMiBannerResponse.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBannerResponse.h"

@implementation WeiMiBannerResponse

- (instancetype)init
{
    if (self = [super init]) {
        _dataArr = [NSMutableArray new];
    }
    return self;
}

- (void)parseResponse:(NSArray *)arr
{
    for (NSDictionary *di in arr) {
        WeiMiHomePageBannerDTO *dto = [[WeiMiHomePageBannerDTO alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];
    }
}

@end
