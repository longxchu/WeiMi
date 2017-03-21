//
//  WeiMiFemaleInvitationRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiFemaleInvitationRequest : WeiMiBaseRequest

-(id)initWithIsAble:(NSString *)isAble
          pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end
