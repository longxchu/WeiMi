//
//  WeiMiBaseRequest.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "YTKRequest.h"
#import "WeiMiBaseResponse.h"

@interface WeiMiBaseRequest : YTKRequest

@property (nonatomic, assign) BOOL showHUD;
/**
 *  请求起飞~~~
 */
//- (void)startWith:(WeiMiBaseResponse *)response WithCompletionBlockWithSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;

///清除所有缓存
- (void)clearAllCache;

@end
