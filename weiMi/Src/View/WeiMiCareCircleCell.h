//
//  WeiMiCareCircleCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiMyCareListModel.h"
#import "WeiMiCircleCateListDTO.h"
#import <UIImageView+WebCache.h>
#import "WeiMiCircleDetailVC.h"

WEIMI_EXTERN const CGFloat myCareItemHeight;
WEIMI_EXTERN const CGFloat myCareTitleHeight;

typedef void (^OnAddNewCareBlock) ();
@interface WeiMiCareCircleCell : WeiMiBaseTableViewCell

@property (nonatomic, copy) NSMutableArray *listArr;
@property (nonatomic, copy) OnAddNewCareBlock onAddNewCareBlock;

- (void)addObject:(NSString *)title image:(NSString *)image;

@end
