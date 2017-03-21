//
//  WeiMiTryoutGroundDetailRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/31.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTryoutGroundDetailRequest.h"

@implementation WeiMiTryoutGroundDetailRequest

{
    
//    NSInteger _pageIndex;
    NSString *_idStr;
}

- (id)initWithIDStr:(NSString *)str{
    self = [super init];
    if (self) {
        _idStr = str;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Cep_detail.html";
}


- (id)requestArgument {
    return @{ @"id": _idStr };
}

@end
