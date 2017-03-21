//
//  WeiMiDeleteChartRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/26.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiDeleteChartRequest.h"

@implementation WeiMiDeleteChartRequest
{
    NSString *_shopId;
//    NSInteger _number;//1为购物产品/2为免费体验产品
}

- (id)initWithShopId:(NSString *)shopId
{
    self = [super init];
    if (self) {
        _shopId = shopId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Shop_delShop.html";
}


- (id)requestArgument {
    return @{
             @"shopId": _shopId,
             };
}
@end
