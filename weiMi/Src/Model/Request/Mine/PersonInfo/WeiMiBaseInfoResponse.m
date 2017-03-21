//
//  WeiMiBaseInfoResponse.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/16.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseInfoResponse.h"

@implementation WeiMiBaseInfoResponse

- (void)parseResponse:(NSDictionary *)dic
{
    self.aboutContext = EncodeStringFromDic(dic, @"aboutContext");
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.aboutTitle = EncodeStringFromDic(dic, @"aboutTitle");
    self.aboutId = EncodeStringFromDic(dic, @"aboutId");
    self.aboutType = EncodeStringFromDic(dic, @"aboutType");
}
@end
