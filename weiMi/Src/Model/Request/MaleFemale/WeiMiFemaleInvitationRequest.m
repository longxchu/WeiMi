//
//  WeiMiFemaleInvitationRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiFemaleInvitationRequest.h"

@implementation WeiMiFemaleInvitationRequest
{
    NSString *_isAble;//sAble=0不显示 1正常 2精华 3置顶 4首页 5推荐
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
    return @"/Infor_nvlists.html";
}

- (id)requestArgument {
    return @{
             @"isAble": _isAble ? _isAble:@"",
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}
@end
