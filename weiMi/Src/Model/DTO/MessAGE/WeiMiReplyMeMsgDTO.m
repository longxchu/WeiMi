//
//  WeiMiReplyMeMsgDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiReplyMeMsgDTO.h"

@implementation WeiMiReplyMeMsgDTO

- (instancetype)init
{
    if (self = [super init]) {
        self.imgURL = TEST_IMAGE_URL;
        self.userName = @"小美女";
        self.time = @"2016-9-8";
        self.commentStr = @"写的不错啊,写的不错啊写的不错啊写的不错啊写的不错啊";
        self.replyStr = @"宫保鸡丁不错啊！宫保鸡丁不错啊!宫保鸡丁不错啊！宫保鸡丁不错啊！宫保鸡丁不错啊！";
        self.tagStr = @"吃货的厨房";
    }
    return self;
}

-(void)encodeFromDictionary:(NSDictionary *)dic
{
    
}

@end
