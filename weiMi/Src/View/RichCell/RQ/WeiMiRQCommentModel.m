//
//  WeiMiRQCommentModel.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRQCommentModel.h"

@implementation WeiMiRQCommentModel

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.createTime = EncodeStringFromDic(dic,@"createTime");
    self.disContent = EncodeStringFromDic(dic,@"disContent");
    self.disId = EncodeStringFromDic(dic,@"disId");
    self.memberId = EncodeStringFromDic(dic,@"memberId");
    self.memberName = EncodeStringFromDic(dic,@"memberName");
}

@end
