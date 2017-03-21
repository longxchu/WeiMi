//
//  WeiMiGoodsDetialCommentDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/12.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiGoodsDetialCommentDTO.h"

@implementation WeiMiGoodsDetialCommentDTO

- (instancetype)init
{
    if (self = [super init]) {
        self.starNum = 4;
        self.date = @"2015-12-21";
        self.content = @"分享就得优惠券，只要分享我们活动链接，就可以得到500元代金券哦 只要分享我们活动链接，就可以得到500元代金券哦";
        self.userName = @"和**你";
    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    
}

@end
