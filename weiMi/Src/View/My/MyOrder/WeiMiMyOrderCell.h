//
//  WeiMiMyOrderCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiOrderDTO.h"

typedef void (^OnLeftHandler) ();
typedef void (^OnRightHandler) ();
typedef NS_ENUM(NSInteger, TRADESTATUS)
{
    TRADESTATUS_DEALSUCEESS,//交易成功
    TRADESTATUS_UNPAY,//未付款
    TRADESTATUS_UNREC,//待收货
};
@interface WeiMiMyOrderCell : WeiMiBaseTableViewCell

@property (nonatomic, copy) OnLeftHandler onLeftHandler;
@property (nonatomic, copy) OnRightHandler onRightHandler;

- (TRADESTATUS)tradeStatus;

- (void)setViewWithDTO:(WeiMiOrderDTO *)dto;

@end
