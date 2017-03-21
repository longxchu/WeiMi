//
//  WeiMiProductCommentListRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/12.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiProductCommentListRequest.h"

@implementation WeiMiProductCommentListRequest
{
NSString *_productId;
NSInteger _pageIndex;
NSInteger _pageSize;
}

-(id)initWithProductId:(NSString *)productId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        _productId = productId;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Msg_list.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"productId": _productId ? _productId : @"",
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}

@end
