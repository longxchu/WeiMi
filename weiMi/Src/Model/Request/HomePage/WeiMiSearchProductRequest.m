//
//  WeiMiSearchProductRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2017/1/8.
//  Copyright © 2017年 madaoCN. All rights reserved.
//

#import "WeiMiSearchProductRequest.h"

@implementation WeiMiSearchProductRequest
{
    NSString *_productName;
}

-(id)initWithProductName:(NSString *)productName
{
    self = [super init];
    if (self) {
        _productName = productName;

    }
    return self;
}

- (NSString *)requestUrl {
    return @"/product_dimProductName.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"ProductName": _productName ? _productName : @"",
             };
}


@end
