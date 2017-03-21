//
//  WeiMiCommentTopicCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/10.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiRQDetailTopicDTO.h"
#import "WeiMiCommentTopicDTO.h"

@interface WeiMiCommentTopicCell : WeiMiBaseTableViewCell

+ (CGFloat)getHeightWithDTO:(WeiMiRQDetailTopicDTO *)dto;

- (void)setViewWithDTO:(WeiMiRQDetailTopicDTO *)dto;

@end
