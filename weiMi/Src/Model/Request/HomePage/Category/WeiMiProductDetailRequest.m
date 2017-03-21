//
//  WeiMiProductDetailRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiProductDetailRequest.h"

@implementation WeiMiProductDetailRequest
{

    NSString *_productId;
}

- (instancetype)initWithProductId:(NSString *)productId
{
    if (self = [super init]) {
        
        _productId = productId;//分类id
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Common_findProduct.html";
}

- (id)requestArgument
{
    return @{
             @"productId":_productId,
             };
}

@end
