//
//  WeiMiShopCartCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiShoppingCartDTO.h"

typedef void (^OnDeleteBlock)(UIButton *selectedBtn);
typedef void (^OnSeletedCheckBoxBlock)(UIButton *selectedBtn);
typedef void (^OnPlusBlock)(UIButton *selectedBtn);
typedef void (^OnMinusBlock)(UIButton *selectedBtn, NSInteger num);

@interface WeiMiShopCartCell : WeiMiBaseTableViewCell

@property (nonatomic, strong) UIButton *checkBoxBtn;

@property (nonatomic, copy) OnDeleteBlock onDeleteBlock;
@property (nonatomic, copy) OnSeletedCheckBoxBlock onSeletedCheckBoxBlock;
@property (nonatomic, copy) OnPlusBlock onPlusBlock;
@property (nonatomic, copy) OnMinusBlock onMinusBlock;

@property (nonatomic, assign) double price;
@property (nonatomic, assign) NSUInteger num;

@property (nonatomic, strong)WeiMiShoppingCartDTO *dto;
- (void)setViewWithDTO:(WeiMiShoppingCartDTO *)dto;


@end
