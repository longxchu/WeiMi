//
//  WeiMiCreditShopCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiCreditTaskDTO.h"

@interface WeiMiCreditShopCell : WeiMiBaseTableViewCell

@property (nonatomic, assign, setter=setClickBtnOn:) BOOL clickBtnOn;
@property (nonatomic, strong) UIButton *clickedBtn;
@property (nonatomic, strong) UIButton *getRewardBtn;

- (void)setViewWithDTO:(WeiMiCreditTaskDTO *)dto;

@end
