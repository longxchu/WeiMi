//
//  WeiMiRQDetailTopicDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRQDetailTopicDTO.h"

@implementation WeiMiRQDetailTopicDTO


- (instancetype)init
{
    if (self = [super init]) {
        self.imgURL = TEST_IMAGE_URL;
        self.level = @"6";
        self.tag = @"楼主";
        
        self.time = @"今日：8:7";
        self.title = @"闺蜜私房话";
        self.user = @"克鲁斯";
        self.subTitle = @"女生专属,聊一切女生想聊的话题 女生专属,聊一切女生想聊的话题女生专属,聊一切女生想聊的话题女生专属,聊一切女生想聊的话题女生专属,聊一切女生想聊的话题女生专属,聊一切女生想聊的话题";
        self.visitNum = @"23";
        self.isAnonymity = YES;
    }
    return self;
}

-(void)encodeFromDictionary:(NSDictionary *)dic
{
    
}

@end
