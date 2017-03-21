//
//  WeiMiTryoutGroundRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/31.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTryoutGroundRequest.h"

@implementation WeiMiTryoutGroundRequest

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
    return @"/Cep_lists.html";
}


- (id)requestArgument {
    return @{
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}
@end
