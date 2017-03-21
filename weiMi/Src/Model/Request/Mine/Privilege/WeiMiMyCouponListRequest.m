//
//  WeiMiMyCouponListRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/30.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyCouponListRequest.h"

@implementation WeiMiMyCouponListRequest
{
    NSString *_memberId;
    NSString *_isAble;//1为产品/2为帖子
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

-(id)initWithMemberId:(NSString *)memberId isAble:(NSString *)isAble
            pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        _memberId = memberId;
        _isAble = isAble;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Common_myJFvous.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"memberId": _memberId,
             @"isAble": _isAble,
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}

@end
