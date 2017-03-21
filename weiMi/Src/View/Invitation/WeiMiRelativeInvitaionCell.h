//
//  WeiMiRelativeInvitaionCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"

typedef void (^OnInvitaitonCellBTNHandler) (BOOL isleft);
@interface WeiMiRelativeInvitaionCell : WeiMiBaseTableViewCell

@property (nonatomic, copy) OnInvitaitonCellBTNHandler onBtnHandler;
@end
