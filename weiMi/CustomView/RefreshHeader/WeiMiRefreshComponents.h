//
//  WeiMiRefreshComponents.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"

@interface WeiMiRefreshComponents : NSObject

/**
 *  默认刷新Header
 */
+ (MJRefreshNormalHeader *)defaultHeaderWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

/**
 *  默认刷新Footer
 */
+ (MJRefreshBackNormalFooter *)defaultFooterWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

@end
