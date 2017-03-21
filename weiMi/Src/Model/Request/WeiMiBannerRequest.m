//
//  WeiMiBannerRequest.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBannerRequest.h"

@implementation WeiMiBannerRequest
{
    NSString *_isAble;
}

- (instancetype)initWithIsAble:(NSString *)isAble
{
    if (self = [super init]) {
        
        _isAble = isAble;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Banner_list.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{
             @"isAble": _isAble ? _isAble :@"1",
             };
}

//- (NSInteger)cacheTimeInSeconds {
//    // 3banner缓存1天
//    return 60 * 60 *  24 * 1;
//}


@end
