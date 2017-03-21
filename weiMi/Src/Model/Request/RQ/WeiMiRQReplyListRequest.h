//
//  WeiMiRQReplyListRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiRQReplyListRequest : WeiMiBaseRequest

-(id)initWithQId:(NSString *)qtId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end
