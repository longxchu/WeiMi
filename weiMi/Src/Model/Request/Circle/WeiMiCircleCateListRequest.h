//
//  WeiMiCircleCateListRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/26.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiCircleCateListRequest : WeiMiBaseRequest

-(id)initWithTypeId:(NSString *)typeId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize memberId:(NSString *)memberId;

@end
