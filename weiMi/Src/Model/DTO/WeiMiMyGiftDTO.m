//
//  WeiMiMyGiftDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyGiftDTO.h"

@implementation WeiMiMyGiftDTO

- (instancetype)init
{
    if (self = [super init]) {
        self.image = [UIImage imageNamed:@"followus_bg480x800"];
        self.titleStr = @"服务窗";
        self.subTitleStr = @"优酷会员体验价【5元】";
        self.timeStr = @"9:20";
    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    
}

@end
