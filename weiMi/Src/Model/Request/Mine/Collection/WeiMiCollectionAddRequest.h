//
//  WeiMiCollectionAddRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiCollectionAddRequest : WeiMiBaseRequest

//新增收藏
-(id)initWithMemberId:(NSString *)memberId entityId:(NSString *)entityId isAble:(NSString *)isAble;

@end
