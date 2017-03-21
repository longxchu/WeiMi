//
//  WeiMiGraceCell.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "HPWealListModel.h"

typedef void(^GraceCellClickLabelHandler)(NSInteger index);
typedef void(^GraceCellClickImgHandler)();

@interface WeiMiGraceCell : WeiMiBaseTableViewCell

@property (nonatomic, copy) NSArray *titleArr;

@property (nonatomic, copy) GraceCellClickLabelHandler clickLabelHandler;
@property (nonatomic, copy) GraceCellClickImgHandler clickImgHandler;


@end
