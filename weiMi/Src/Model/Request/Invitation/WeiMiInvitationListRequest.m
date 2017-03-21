//
//  WeiMiInvitationListRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiInvitationListRequest.h"

@implementation WeiMiInvitationListRequest
{
    NSString *_isAble;
    NSInteger _pageIndex;
    NSInteger _pageSize;
    NSString *_ringId;
}

-(id)initWithIsAble:(NSString *)isAble ringId:(NSString *)ringId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        _isAble = isAble;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
        _ringId = ringId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Infor_lists.html";
}


- (id)requestArgument {
    if (_pageSize == 0 && !_isAble) {
        return @{};
    }
    return @{
             @"isAble":_isAble ? _isAble:@"",
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             @"ringId":_ringId,
             };
}
@end
