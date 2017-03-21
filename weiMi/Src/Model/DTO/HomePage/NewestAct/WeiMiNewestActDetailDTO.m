//
//  WeiMiNewestActDetailDTO.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiNewestActDetailDTO.h"

@implementation WeiMiNewestActDetailDTO

- (void)encodeFromDictionary:(NSDictionary *)dic
{
    self.atImg = EncodeStringFromDic(dic, @"atImg");
    self.createTime = EncodeStringFromDic(dic, @"createTime");
    self.canyu = EncodeStringFromDic(dic, @"canyu");
    self.dzscription = EncodeStringFromDic(dic, @"description");
    self.atId = EncodeStringFromDic(dic, @"atId");
    
    self.isAble = EncodeStringFromDic(dic, @"isAble");
    self.atTime = EncodeStringFromDic(dic, @"atTime");
    self.atTitle = EncodeStringFromDic(dic, @"atTitle");
    self.atContent = EncodeStringFromDic(dic, @"atContent");
    self.yuedu = EncodeStringFromDic(dic, @"yuedu");
    
    NSRegularExpression *regularEx = [NSRegularExpression regularExpressionWithPattern:@"src=\"" options:0 error:nil];
    self.atContent = [regularEx stringByReplacingMatchesInString:self.atContent options:0 range:NSMakeRange(0, self.atContent.length) withTemplate:[NSString stringWithFormat:@"src=\"%@", BASE_URL]];
}


@end
