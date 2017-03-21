//
//  WeiMiRQDetailCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
//#import "WeiMiRQDetailTopicDTO.h"
#import "WeiMiMaleFemaleRQDTO.h"

@interface WeiMiRQDetailCell : WeiMiBaseTableViewCell

+ (CGFloat)getHeightWithDTO:(WeiMiMaleFemaleRQDTO *)dto;

- (void)setViewWithDTO:(WeiMiMaleFemaleRQDTO *)dto;

@end
