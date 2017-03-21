//
//  WeiMiTryoutGroundDetailDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/31.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTryoutGroundDetailDTO.h"

@implementation WeiMiTryoutGroundDetailDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.applyId = EncodeStringFromDic(dic, @"applyId");
    self.createTime = EncodeStringFromDic(dic, @"createTime");
    self.ssg = EncodeStringFromDic(dic, @"ssg");
    self.weidao = EncodeStringFromDic(dic, @"weidao");
    self.sex = EncodeStringFromDic(dic, @"sex");
    
    self.fuwu = EncodeStringFromDic(dic, @"fuwu");
    self.zgsg = EncodeStringFromDic(dic, @"zgsg");
    self.applyImg = EncodeStringFromDic(dic, @"applyImg");
    self.weidao = EncodeStringFromDic(dic, @"weidao");
    self.sign = EncodeStringFromDic(dic, @"sign");
    
    self.id = EncodeStringFromDic(dic, @"id");
    self.content = EncodeStringFromDic(dic, @"content");
    self.title = EncodeStringFromDic(dic, @"title");
    self.applyName = EncodeStringFromDic(dic, @"applyName");
    self.waixing = EncodeStringFromDic(dic, @"waixing");
    
    self.ckfy = EncodeStringFromDic(dic, @"ckfy");
    self.age = EncodeStringFromDic(dic, @"age");
    self.memberId = EncodeStringFromDic(dic, @"memberId");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.memberName = EncodeStringFromDic(dic, @"memberName");
    self.applyCz = EncodeStringFromDic(dic, @"applyCz");
    self.applyColor = EncodeStringFromDic(dic, @"applyColor");
    self.applyBrand = EncodeStringFromDic(dic, @"applyBrand");
    self.headImgPath = EncodeStringFromDic(dic, @"headImgPath");
}

@end
