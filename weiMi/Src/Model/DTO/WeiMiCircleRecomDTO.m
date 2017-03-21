//
//  WeiMiCircleRecomDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/17.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleRecomDTO.h"

@implementation WeiMiCircleRecomDTO

- (instancetype)init
{
    if (self = [super init]) {
        self.imgURL = TEST_IMAGE_URL;
        self.time = @"今日：807";
        self.title = @"闺蜜私房话";
        self.subTitle = @"女生专属,聊一切女生想聊的话题";
    }
    return self;
}

-(void)encodeFromDictionary:(NSDictionary *)dic
{
    
}

@end
