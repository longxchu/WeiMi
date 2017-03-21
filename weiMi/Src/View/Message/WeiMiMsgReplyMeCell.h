//
//  WeiMiMsgReplyMeCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiReplyMeMsgDTO.h"


@interface WeiMiMsgReplyMeCell : WeiMiBaseTableViewCell

+ (CGFloat)getHeightWithDTO:(WeiMiReplyMeMsgDTO *)dto;
- (void)setViewWithDTO:(WeiMiReplyMeMsgDTO *)dto;

@end
