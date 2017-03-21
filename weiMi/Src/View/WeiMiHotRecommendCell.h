//
//  WeiMiHotRecommendCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"


typedef void (^OnClickedChangeBtn) ();
typedef void (^OnClickedItemBtn) ();

@interface WeiMiHotRecommendCell : WeiMiBaseTableViewCell

@property (nonatomic, copy) OnClickedChangeBtn onClickedChangeBtn;
@property (nonatomic, copy) OnClickedItemBtn onClickedItemBtn;

- (void)setViewWithDTOs:(NSArray *)dtos;


@end
