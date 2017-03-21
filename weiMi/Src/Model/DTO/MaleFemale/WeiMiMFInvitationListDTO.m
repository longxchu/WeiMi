//
//  WeiMiMFInvitationListDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMFInvitationListDTO.h"

@implementation WeiMiMFInvitationListDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.infoId = EncodeStringFromDic(dic, @"infoId");
    self.infoTitle = EncodeStringFromDic(dic, @"infoTitle");
    self.dzscription = EncodeStringFromDic(dic, @"description");
    self.imgPath = EncodeStringFromDic(dic, @"imgPath");
    
    self.content = EncodeStringFromDic(dic, @"content");
    self.createTime = EncodeStringFromDic(dic, @"createTime");
    self.type = EncodeStringFromDic(dic, @"type");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    self.ringId = EncodeStringFromDic(dic, @"ringId");
    self.dianzan = EncodeStringFromDic(dic, @"dianzan");
    self.pinglun = EncodeStringFromDic(dic, @"pinglun");
    self.memberName = EncodeStringFromDic(dic, @"memberName");
    self.collectId = EncodeStringFromDic(dic, @"collectId");
}

@end
