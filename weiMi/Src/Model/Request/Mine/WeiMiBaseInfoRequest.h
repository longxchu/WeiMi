//
//  WeiMiBaseInfoRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/16.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

//aboutType=1积分规则
//aboutType=2关于我们
//aboutType=3关于微信
//aboutType=4客服信息
typedef NS_ENUM(NSInteger, INFOTYPE)
{
    INFOTYPE_CREDITRULE = 1,
    INFOTYPE_ABOUTUS = 2,
    INFOTYPE_ABOUTWECHAT = 3,
    INFOTYPE_SERVICEINFO = 4,
    
};


@interface WeiMiBaseInfoRequest : WeiMiBaseRequest

@end
