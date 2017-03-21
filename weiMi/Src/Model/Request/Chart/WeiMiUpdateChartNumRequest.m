//
//  WeiMiUpdateChartNumRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/26.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiUpdateChartNumRequest.h"

@implementation WeiMiUpdateChartNumRequest
{
    NSString *_shopId;
    NSInteger _number;//1为购物产品/2为免费体验产品
}

- (id)initWithShopId:(NSString *)shopId number:(NSInteger)number
{
    self = [super init];
    if (self) {
        _shopId = shopId;
        _number = number;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Shop_editNumber.html";
}


- (id)requestArgument {
    return @{
             @"number": [NSNumber numberWithInteger:_number],
             @"shopId": _shopId,
             };
}
@end
