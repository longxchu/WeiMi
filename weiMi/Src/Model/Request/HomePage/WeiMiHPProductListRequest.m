//
//  WeiMiHPProductListRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHPProductListRequest.h"

@implementation WeiMiHPProductListRequestModel


@end

@implementation WeiMiHPProductListRequest
{
//    NSString *_menuId;
//    NSString *_brandId;
//    NSString *_proTypeId;
//    NSString *_strSort;
//    NSString *_isAble;
    WeiMiHPProductListRequestModel *_model;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

-(id)initWithModel:(WeiMiHPProductListRequestModel *)model pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        _model = model;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Common_productlist.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"menuId": _model.menuId ? _model.menuId:@"",
             @"brandId": _model.brandId ? _model.brandId:@"",
             @"proTypeId": _model.proTypeId ? _model.proTypeId:@"",
             @"isAble": _model.isAble ? _model.isAble:@"",
             @"strSort": _model.strSort ? _model.strSort:@"",
             
             @"pageIndex": [NSNumber numberWithInteger:_pageIndex],
             @"pageSize": [NSNumber numberWithInteger:_pageSize],
             };
}

@end
