//
//  WeiMiCreditExchangeListRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/12/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCreditExchangeListRequest.h"

@implementation WeiMiCreditExchangeListRequest
{
    NSString *_memberId;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}


-(id)initWithMemberId:(NSString *)memberId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        _memberId = memberId;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Common_myJFproducts.html";
}

- (id)requestArgument {
    return @{
            @"memberId": _memberId ? _memberId:@"",
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}
@end
