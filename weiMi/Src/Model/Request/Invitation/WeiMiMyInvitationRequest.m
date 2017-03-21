//
//  WeiMiMyInvitationRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyInvitationRequest.h"

@implementation WeiMiMyInvitationRequest
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
    return @"/Infor_mylist.html";
}

- (id)requestArgument {
    
    return @{
             @"memberId":_memberId,
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}
@end
