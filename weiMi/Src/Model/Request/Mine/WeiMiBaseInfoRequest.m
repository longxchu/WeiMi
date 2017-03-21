//
//  WeiMiBaseInfoRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/16.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseInfoRequest.h"



@implementation WeiMiBaseInfoRequest

{
    INFOTYPE _infoType;
}

- (id)initWithAboutType:(INFOTYPE )infoType
{
    self = [super init];
    if (self) {
        _infoType = infoType;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/Member_register.html";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"infoType": [NSNumber numberWithInteger:_infoType],
             };
}


@end
