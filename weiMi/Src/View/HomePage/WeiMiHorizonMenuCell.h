//
//  WeiMiHorizonMenuCell.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"

typedef void (^OnMoreBTN)();
typedef void (^OnItem)(NSInteger);
@interface WeiMiHorizonMenuCell : WeiMiBaseTableViewCell

/**
 *  添加标签和图片资源
 */
- (void)addObjects:(NSArray *)titles images:(NSArray *)images;

@property (nonatomic, copy) OnMoreBTN onMoreBTN;
@property (nonatomic, copy) OnItem onItem;
@end
