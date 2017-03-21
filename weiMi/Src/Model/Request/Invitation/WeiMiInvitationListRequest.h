//
//  WeiMiInvitationListRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiInvitationListRequest : WeiMiBaseRequest

-(id)initWithIsAble:(NSString *)isAble ringId:(NSString *)ringId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end
