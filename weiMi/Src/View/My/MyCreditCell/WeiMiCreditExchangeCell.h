//
//  WeiMiCreditExchangeCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiCreditExchangeDTO.h"
#import "WeiMiMyCreditDTO.h"

typedef void (^OnButtonHandler) ();
@interface WeiMiCreditExchangeCell : WeiMiBaseTableViewCell
@property (nonatomic, copy) OnButtonHandler onButtonHandler;

- (void)setViewWithDTO:(WeiMiCreditExchangeDTO *)dto;
- (void)setViewWithCreditDTO:(WeiMiMyCreditDTO *)dto;

@end
