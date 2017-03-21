//
//  WeiMiAppRecommandResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiAppRecommandResponse.h"

@implementation WeiMiAppRecommandDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.appName = EncodeStringFromDic(dic, @"appName");
    self.andriodUrl = EncodeStringFromDic(dic, @"andriodUrl");
    self.appId = EncodeStringFromDic(dic, @"appId");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.appLogo = EncodeStringFromDic(dic, @"appLogo");
    self.iosUrl = EncodeStringFromDic(dic, @"iosUrl");
}


@end

@implementation WeiMiAppRecommandResponse

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
        WeiMiAppRecommandDTO *dto = [[WeiMiAppRecommandDTO alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];
    }
    
}

@end
