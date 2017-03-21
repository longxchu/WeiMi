//
//  WeiMiRQReplyListResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRQReplyListResponse.h"

@implementation WeiMiRQReplyListResponse

- (instancetype)init
{
    if (self = [super init]) {
        
        self.dataArr = [NSMutableArray new];
    }
    return self;
}

- (void)parseResponse:(NSDictionary *)dic
{
    for (NSDictionary *di in EncodeArrayFromDic(dic, @"result"))
    {
        WeiMiRQCommentModel *dto = [[WeiMiRQCommentModel alloc] init];
        [dto encodeFromDictionary:di];
        [_dataArr addObject:dto];
    }
}


@end
