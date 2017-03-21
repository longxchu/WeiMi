//
//  WeiMiProductCommentListRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/12.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiProductCommentListRequest : WeiMiBaseRequest

-(id)initWithProductId:(NSString *)productId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end
