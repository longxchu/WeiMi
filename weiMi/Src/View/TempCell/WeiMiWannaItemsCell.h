//
//  WeiMiWannaItemsCell.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/21.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"

typedef void (^OnWannCellItemHandler) (WeiMiBaseDTO *);

@interface WeiMiWannaItemsCell : WeiMiBaseTableViewCell

@property (nonatomic, copy) OnWannCellItemHandler onWannCellItemHandler;

- (void)setViewWithLeftDTO:(WeiMiBaseDTO *)ldto rightDTO:(WeiMiBaseDTO *)rdto;

+ (CGFloat)getHeight;

@end
