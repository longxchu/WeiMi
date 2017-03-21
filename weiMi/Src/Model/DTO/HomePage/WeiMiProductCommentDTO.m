//
//  WeiMiProductCommentDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/12.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiProductCommentDTO.h"

@implementation WeiMiProductCommentDTO

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.fwtd = EncodeNumberFromDic(dic, @"fwtd").integerValue;
    self.msxf = EncodeNumberFromDic(dic, @"msxf").integerValue;
    self.createTime = EncodeStringFromDic(dic, @"createTime");
    self.strName = EncodeStringFromDic(dic, @"strName");
    
    self.imgPath = EncodeStringFromDic(dic, @"imgPath");
    self.fhsd = EncodeStringFromDic(dic, @"fhsd");
    self.msgId = EncodeStringFromDic(dic, @"msgId") ;
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    
    self.msgContext = EncodeStringFromDic(dic, @"msgContext");
    self.productId = EncodeStringFromDic(dic, @"productId");
}

@end
