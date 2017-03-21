//
//  WeiMiHotMoudleItem.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
/**
 *  DTO
 */
#import "WeiMiHotCommandDTO.h"

@interface WeiMiHotMoudleCell : WeiMiBaseTableViewCell

- (void)setViewWithDTO:(WeiMiHotCommandDTO *)dto;

@end
