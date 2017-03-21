//
//  WeiMiMyOrderListRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyOrderListRequest.h"

@implementation WeiMiMyOrderListRequest
{
    NSString *_memberId;
    NSString *_orderStatus;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

-(id)initWithMemberId:(NSString *)memberId orderStatus:(NSString *)orderStatus pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        _memberId = memberId;
        _orderStatus = orderStatus;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/order_orderlist.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"memberId": _memberId,
             @"orderStatus": _orderStatus,
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}


@end
