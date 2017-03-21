//
//  WeiMiTryoutListRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiTryoutListRequest : WeiMiBaseRequest

-(id)initWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end
