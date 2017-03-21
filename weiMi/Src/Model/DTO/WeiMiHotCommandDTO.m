//
//  WeiMiHotCommandDTO.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/17.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHotCommandDTO.h"

@implementation WeiMiHotCommandDTO

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.createTime = EncodeStringFromDic(dic, @"createTime");
    self.ringId = EncodeStringFromDic(dic, @"ringId");
    self.infoId = EncodeStringFromDic(dic, @"infoId");
    self.type = EncodeStringFromDic(dic, @"type");
    
    self.content = EncodeStringFromDic(dic, @"content");
    self.dzscription = EncodeStringFromDic(dic, @"description");
    self.imgPath = EncodeStringFromDic(dic, @"imgPath") ;
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    self.memberName = EncodeStringFromDic(dic, @"memberName");
    self.infoTitle = EncodeStringFromDic(dic, @"infoTitle");
    self.sex = EncodeStringFromDic(dic, @"sex");
    self.headImgPath = EncodeStringFromDic(dic, @"headImgPath");
    self.pinglun = EncodeStringFromDic(dic, @"description").integerValue;
    self.dianzan = EncodeStringFromDic(dic, @"dianzan").integerValue;
    self.isAble = EncodeStringFromDic(dic, @"isAble").integerValue;
    
    self.headImgPath = [self.headImgPath stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
}
@end
