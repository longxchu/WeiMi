//
//  WeiMiCircleRecommandRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/1.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiCircleRecommandRequest : WeiMiBaseRequest

-(id)initWithTypeId:(NSString *)typeId
          pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end
