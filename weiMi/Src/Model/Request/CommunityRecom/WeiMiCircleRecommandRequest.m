//
//  WeiMiCircleRecommandRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/1.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleRecommandRequest.h"

@implementation WeiMiCircleRecommandRequest
{
    NSString *_typeId;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

-(id)initWithTypeId:(NSString *)typeId
          pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        _typeId = typeId;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Ring_randlist.html";
}

- (id)requestArgument {
    if (_pageSize == 0 && !_typeId) {
        return @{};
    }
    return @{
             @"typeId": _typeId ? _typeId:@"",
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}

@end
