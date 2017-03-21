//
//  WeiMiUpdateChartNumRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/26.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiUpdateChartNumRequest : WeiMiBaseRequest

- (id)initWithShopId:(NSString *)shopId number:(NSInteger)number;

@end
