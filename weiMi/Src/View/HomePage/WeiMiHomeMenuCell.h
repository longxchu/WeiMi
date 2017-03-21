//
//  WeiMiHomeMenuCell.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"

@protocol WeiMiHomeMenuCellDelegate <NSObject>

@optional
- (void)didSelectedItemAtIndex:(NSIndexPath *)indexPath;

@end

@interface WeiMiHomeMenuCell : WeiMiBaseTableViewCell

@property (nonatomic, weak) id <WeiMiHomeMenuCellDelegate> delegate;

/**
 *  添加标签和图片资源
 */
- (void)addObjects:(NSArray *)titles images:(NSArray *)images;

@end
