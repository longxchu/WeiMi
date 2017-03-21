//
//  WeiMiLoginResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiLoginResponse.h"
#import "WeiMiUserCenter.h"

@implementation WeiMiLoginResponse


-(void)parseResponse:(NSDictionary *)dic
{
    [WeiMiUserCenter sharedInstance].userInfoDTO = [[WeiMiUserInfoDTO alloc] init];
    [[WeiMiUserCenter sharedInstance].userInfoDTO encodeFromDictionary:dic];
}

@end
