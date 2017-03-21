//
//  WeiMiGoodDetailPriceCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiMiGoodDetailPriceModel : NSObject

@property (nonatomic, strong) NSString *salesVolume;//	销量
@property (nonatomic, strong) NSString *price;//价格
@property (nonatomic, strong) NSString *productName;//产品名称
@end

@interface WeiMiGoodDetailPriceCell : UITableViewCell

- (void)setViewWith:(WeiMiGoodDetailPriceModel *)model;

@end
