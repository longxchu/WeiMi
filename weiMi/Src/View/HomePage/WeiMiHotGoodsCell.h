//
//  WeiMiHotGoodsCell.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiPriceGoodView.h"

@class WeiMiHotGoodsCell;
@protocol WeiMiHotGoodsCellDelegate <NSObject>

@optional

- (void)didSelectedView:(WeiMiHotGoodsCell *)cell atIndex:(NSUInteger)idx;

@end

@interface WeiMiHotGoodsCell : WeiMiBaseTableViewCell


@property (nonatomic, strong) UIButton *rightImageView;//右侧图片
@property (nonatomic, strong) UIButton *rightImageView_2;//左下角图片
@property (nonatomic, strong) UIButton *rightImageView_3;//右下角图片
    
@property (nonatomic, strong) WeiMiPriceGoodView *priceGoodView;

@property (nonatomic, weak) id <WeiMiHotGoodsCellDelegate> delegate;

@end
