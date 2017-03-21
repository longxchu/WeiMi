//
//  WeiMiMaleFemaleRQDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/14.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMaleFemaleRQDTO.h"

@implementation WeiMiMaleFemaleRQDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.qtTitle = EncodeStringFromDic(dic, @"qtTitle");
    self.qtId = EncodeStringFromDic(dic, @"qtId");
    self.createTime = EncodeStringFromDic(dic, @"createTime");
    self.niming = EncodeStringFromDic(dic, @"niming");
    self.qtContent = EncodeStringFromDic(dic, @"qtContent");
    
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    
    self.memberName = EncodeStringFromDic(dic, @"memberName");
    self.type = EncodeNumberFromDic(dic, @"type").integerValue;
    self.pinglun = EncodeNumberFromDic(dic, @"pinglun").integerValue;
    self.yuedu = EncodeStringFromDic(dic, @"yuedu").integerValue;
}

@end
