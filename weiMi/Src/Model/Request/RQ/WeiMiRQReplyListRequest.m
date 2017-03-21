//
//  WeiMiRQReplyListRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRQReplyListRequest.h"

@implementation WeiMiRQReplyListRequest
{
    NSString *_qtId;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

-(id)initWithQId:(NSString *)qtId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        _qtId = qtId;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Qt_asklist.html";
}

- (id)requestArgument {
    
    return @{
             @"qtId":_qtId,
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}


@end
