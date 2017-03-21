//
//  WeiMiTryoutListRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTryoutListRequest.h"

@implementation WeiMiTryoutListRequest

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
    return @"/Apply_lists.html";
}


- (id)requestArgument {
    return @{
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}

@end
