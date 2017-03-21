//
//  WeiMiRefreshComponents.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRefreshComponents.h"

@implementation WeiMiRefreshComponents

/**
 *  默认刷新Header
 */
+ (MJRefreshNormalHeader *)defaultHeaderWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    return header;
}

/**
 *  默认刷新Footer
 */
+ (MJRefreshBackNormalFooter *)defaultFooterWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:refreshingBlock];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    footer.automaticallyChangeAlpha = YES;
    // 隐藏时间
//    footer.lastUpdatedTimeLabel.hidden = YES;
//    footer.ignoredScrollViewContentInsetBottom = 10;
    return footer;
}

@end
