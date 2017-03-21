//
//  WeiMiLogisticsStatusCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/15.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"

typedef NS_ENUM(NSInteger, YinzhiDirectoryCellStatus){
    // 首个cell
    YinzhiDirectoryCellStatus_upper,
    // 中间的cell
    YinzhiDirectoryCellStatus_mid,
    // 最后一个cell
    YinzhiDirectoryCellStatus_bottom,
    //只有单独一个cell
    YinzhiDirectoryCellStatus_single,
};

@interface WeiMiLogisticsStatusCell : WeiMiBaseTableViewCell

- (instancetype)initWithStatus:(YinzhiDirectoryCellStatus)status reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setViewWithTitle:(NSString *)title date:(NSString *)date;
+ (CGFloat)getHeightWithTitle:(NSString *)title date:(NSString *)date;
@end
