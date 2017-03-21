//
//  WeiMiCommentTopicDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/10.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCommentTopicDTO.h"

@implementation WeiMiCommentTopicDTO


- (instancetype)init
{
    if (self = [super init]) {
        self.imgURL = TEST_IMAGE_URL;
        self.level = @"6";
        self.user = @"克鲁斯";
        self.content = @"女生专属,聊一切女生想聊的话题 女生专属,聊一切女生想聊的话题女生专属,聊一切女生想聊的话题女生专属,聊一切女生想聊的话题女生专属,聊一切女生想聊的话题女生专属,聊一切女生想聊的话题";
        self.upNum = @"23";
        self.downNum = @"58";
    }
    return self;
}

-(void)encodeFromDictionary:(NSDictionary *)dic
{
    
}

@end
