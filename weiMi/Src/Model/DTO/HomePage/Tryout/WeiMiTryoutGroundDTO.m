//
//  WeiMiTryoutGroundDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/31.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTryoutGroundDTO.h"

@implementation WeiMiTryoutGroundDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.title = EncodeStringFromDic(dic, @"title");
    self.createTime = EncodeStringFromDic(dic, @"createTime");
    self.memberName = EncodeStringFromDic(dic, @"memberName");
    self.headImgPath = EncodeStringFromDic(dic, @"headImgPath");
    self.applyImg = EncodeStringFromDic(dic, @"applyImg");


}

@end
