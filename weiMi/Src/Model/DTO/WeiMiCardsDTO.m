//
//  WeiMiCardsDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCardsDTO.h"

@implementation WeiMiCardsDTO

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.tagStr = EncodeStringFromDic(dic, @"infoTitle");
    self.titleStr = EncodeStringFromDic(dic, @"description");
    self.commentNum = EncodeStringFromDic(dic, @"pinglun");
    
    self.infoId = EncodeStringFromDic(dic, @"infoId");
    self.imgPath = EncodeStringFromDic(dic, @"imgPath");
    self.content = EncodeStringFromDic(dic, @"content");
    self.createTime = EncodeStringFromDic(dic, @"createTime");
    self.type = EncodeStringFromDic(dic, @"type");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    self.ringId = EncodeStringFromDic(dic, @"ringId");
    self.dianzan = EncodeStringFromDic(dic, @"dianzan");
}
@end
