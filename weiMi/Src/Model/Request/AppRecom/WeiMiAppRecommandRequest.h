//
//  WeiMiAppRecommandRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiAppRecommandRequest : WeiMiBaseRequest

-(id)initWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end
