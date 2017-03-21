//
//  WeiMiCommentListRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCommentListRequest.h"

@implementation WeiMiCommentListRequest
{
    NSString *_infoId;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

-(id)initWithInfoId:(NSString *)infoId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        _infoId = infoId;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Dis_lists.html";
}

- (id)requestArgument {

    return @{
             @"infoId":_infoId ? _infoId:@"",
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}
@end
