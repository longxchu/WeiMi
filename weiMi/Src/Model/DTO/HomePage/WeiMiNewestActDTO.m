//
//  WeiMiNewestActDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiNewestActDTO.h"

@implementation WeiMiNewestActDTO

- (instancetype)init
{
    if (self = [super init]) {
        self.imgURL = TEST_IMAGE_URL;
        self.title = @"分享就得优惠券";
        self.detailTitle = @"分享就得优惠券，只要分享我们活动链接，就可以得到500元代金券哦";
        self.activityPeriod = @"9/1~9/10";
        self.joinMember = 10;
    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.imgURL = EncodeStringFromDic(dic, @"atImg");
    self.title = EncodeStringFromDic(dic, @"atTitle");
    self.detailTitle = EncodeStringFromDic(dic, @"description");
    self.activityPeriod = EncodeStringFromDic(dic, @"atTime");
    self.joinMember = EncodeStringFromDic(dic, @"canyu").integerValue;
    
    self.createTime = EncodeStringFromDic(dic, @"createTime");
    self.atId = EncodeStringFromDic(dic, @"atId");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.atContent = EncodeStringFromDic(dic, @"atContent");
    self.yuedu = EncodeStringFromDic(dic, @"yuedu");
}

@end
