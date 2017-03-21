//
//  WeiMiMaleRQRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/14.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMaleRQRequest.h"

@implementation WeiMiMaleRQRequest
{
    NSString *_isAble;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

-(id)initWithIsAble:(NSString *)isAble pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        _isAble = isAble;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Qt_nanlists.html";
}


- (id)requestArgument {
    if (_pageSize == 0 && !_isAble) {
        return @{};
    }
    return @{
             @"isAble":_isAble ? _isAble:@"",
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}
@end
