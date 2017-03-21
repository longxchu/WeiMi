//
//  WeiMiHPMenuRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHPMenuRequest.h"

@implementation WeiMiHPMenuRequest
{

}


- (NSString *)requestUrl {
    return @"/Common_menulist.html";
}


- (NSInteger)cacheTimeInSeconds {
    // 3banner缓存一天
    return 60 * 60 *  24 * 1;
}


@end
