//
//  WeiMiShopBottomBar.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

typedef void (^OnSelectAll) ();

typedef NS_ENUM(NSInteger, SHOPBOTTOMSTATUS)
{
    SHOPBOTTOMSTATUS_UPSIDE,
    SHOPBOTTOMSTATUS_LEFTSIDE,
};

@interface WeiMiShopBottomBar : WeiMiBaseView

@property (nonatomic, copy) OnSelectAll onSelectAll;

/**
 *  重新布局
 */
- (void)reLayoutLabelWithStat:(SHOPBOTTOMSTATUS)status;

- (void)setViewWithPrice:(double)price num:(NSUInteger)num;

@end
