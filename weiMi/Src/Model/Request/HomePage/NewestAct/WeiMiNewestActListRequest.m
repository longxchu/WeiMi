//
//  WeiMiNewestActListRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/25.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiNewestActListRequest.h"

@implementation WeiMiNewestActListRequest
{

    NSInteger _pageIndex;
    NSInteger _pageSize;
}

-(id)initWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Act_lists.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}
@end
