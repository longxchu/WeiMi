//
//  WeiMiPurchaseGoodCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/30.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"

@interface WeiMiPurchaseGoodCell : UIView

- (void)setGoodProperty:(NSString *)str;
- (void)setPrice:(NSString *)price;

- (void)setGoodPrice:(NSString *)price img:(NSString *)img;

@end
