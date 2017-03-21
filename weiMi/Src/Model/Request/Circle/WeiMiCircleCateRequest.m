//
//  WeiMiCircleCateRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/26.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleCateRequest.h"

@implementation WeiMiCircleCateRequest

- (NSString *)requestUrl {
    return @"/Type_typelist.html";
}


- (NSInteger)cacheTimeInSeconds {
    // 缓存1天
    return 60 * 60 *  24 * 1;
}
@end
