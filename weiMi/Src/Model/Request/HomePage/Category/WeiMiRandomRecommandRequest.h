//
//  WeiMiRandomRecommandRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiRandomRecommandRequest : WeiMiBaseRequest

- (instancetype)initWithIsAble:(NSString *)isAble brandId:(NSString *)brandId proTypeId:(NSString *)proTypeId;

@end
