//
//  WeiMiMaleInvitationRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMaleInvitationRequest.h"

@implementation WeiMiMaleInvitationRequest
{
    NSString *_isAble;//isAble=2时，指精华帖子 isAble=3时,指置顶帖子
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

-(id)initWithIsAble:(NSString *)isAble
            pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
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
    return @"/Infor_nanlists.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"isAble": _isAble ? _isAble:@"",
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}
@end
