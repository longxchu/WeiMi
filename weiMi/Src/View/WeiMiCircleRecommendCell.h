//
//  WeiMiCircleRecommendCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiCircleMouleCell.h"


typedef void (^OnClickedChangeBtn) ();
typedef void (^OnMoreCircleBtn) ();
typedef void (^OnItemHandler) (NSInteger idx);
@interface WeiMiCircleRecommendCell : WeiMiBaseTableViewCell

@property (nonatomic, copy) OnClickedChangeBtn onClickedChangeBtn;
@property (nonatomic, copy) OnMoreCircleBtn onMoreCircleBtn;
@property (nonatomic, copy) OnCareBtnHandler onCareBtnInCellHandler;
@property (nonatomic, copy) OnItemHandler onItemHandler;
@property (nonatomic, assign) BOOL hiddenBtn;
- (void)setViewWithDTOs:(NSArray *)dtos;

@end
