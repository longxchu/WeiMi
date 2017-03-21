//
//  WeiMiMyHPItemsCell.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"

@class WeiMiMyHPItemsCell;
@protocol WeiMiMyHPItemsCellDelegate <NSObject>

- (void)cell:(WeiMiMyHPItemsCell *)cell didSelectedAtIndex:(NSInteger)index;

@end

@interface WeiMiMyHPItemsCell : WeiMiBaseTableViewCell

@property (nonatomic, weak) id <WeiMiMyHPItemsCellDelegate> delegate;

@end
