//
//  WeiMiHPBrandRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHPBrandRequest.h"

@implementation WeiMiHPBrandRequest
{
}


- (NSString *)requestUrl {
    return @"/Common_brandlist.html";
}


- (NSInteger)cacheTimeInSeconds {
    // 3banner缓存1天
    return 60 * 60 *  24 * 1;
}

@end
