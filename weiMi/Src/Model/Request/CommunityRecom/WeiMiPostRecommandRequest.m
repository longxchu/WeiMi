//
//  WeiMiPostRecommandRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/1.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPostRecommandRequest.h"

@implementation WeiMiPostRecommandRequest
{
    NSString *_ringId;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

-(id)initWithRingId:(NSString *)ringId
          pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        _ringId = ringId;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Infor_randlist.html";
}

- (id)requestArgument {
    if (_pageSize == 0 && !_ringId) {
        return @{};
    }
    return @{
             @"ringId": _ringId ? _ringId:@"",
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}


@end
