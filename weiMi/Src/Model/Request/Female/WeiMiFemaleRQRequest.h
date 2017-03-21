//
//  WeiMiFemaleRQRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiFemaleRQRequest : WeiMiBaseRequest

-(id)initWithIsAble:(NSString *)isAble pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end
