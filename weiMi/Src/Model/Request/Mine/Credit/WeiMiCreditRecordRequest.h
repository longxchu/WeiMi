//
//  WeiMiCreditRecordRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiCreditRecordRequest : WeiMiBaseRequest


-(id)initWithMemberId:(NSString *)memberId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end
