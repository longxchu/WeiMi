//
//  WeiMiRandomRecommandRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRandomRecommandRequest.h"

@implementation WeiMiRandomRecommandRequest
{
    NSString *_isAble;
    NSString *_brandId;
    NSString *_proTypeId;
}

- (instancetype)initWithIsAble:(NSString *)isAble brandId:(NSString *)brandId proTypeId:(NSString *)proTypeId
{
    if (self = [super init]) {
        
        _isAble = isAble;//显示数量
        _brandId = brandId;//brandId
        _proTypeId = proTypeId;//分类id
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Common_randomProduct.html";
}

- (id)requestArgument
{
    return @{
             @"isAble": _isAble ? _isAble :@"",
             @"brandId" : _brandId ? _brandId:@"",
             @"proTypeId":_proTypeId ? _proTypeId:@"",
             };
}

@end
