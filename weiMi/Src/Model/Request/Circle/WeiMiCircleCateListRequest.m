//
//  WeiMiCircleCateListRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/26.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleCateListRequest.h"

@implementation WeiMiCircleCateListRequest
{
    NSString *_typeId;
    NSInteger _pageIndex;
    NSInteger _pageSize;
    NSString *_memberId;
}

-(id)initWithTypeId:(NSString *)typeId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize memberId:(NSString *)memberId
{
    self = [super init];
    if (self) {
        _typeId = typeId;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
        _memberId = memberId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Ring_lists.html";
}


- (id)requestArgument {
    if (_pageSize == 0 && !_typeId) {
        return @{};
    }
    return @{
             @"typeId":_typeId ? _typeId:@"",
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             @"memberId":_memberId ? _memberId:@"",
             };
}
@end
