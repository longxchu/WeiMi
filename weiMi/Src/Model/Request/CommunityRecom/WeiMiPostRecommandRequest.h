//
//  WeiMiPostRecommandRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/1.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiPostRecommandRequest : WeiMiBaseRequest

-(id)initWithRingId:(NSString *)ringId
          pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end