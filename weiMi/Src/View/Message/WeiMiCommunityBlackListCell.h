//
//  WeiMiCommunityBlackListCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"

typedef void (^OnDeleteHandler)();
@interface WeiMiCommunityBlackListCell : WeiMiBaseTableViewCell

@property (nonatomic, copy) OnDeleteHandler onDeleteHandler;

@end
