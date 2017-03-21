//
//  WeiMiGoodsDetailCommentCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/12.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WeiMiGoodsDetialCommentDTO.h"
#import "WeiMiProductCommentDTO.h"

@interface WeiMiGoodsDetailCommentCell : UITableViewCell

+ (CGFloat)getHeightWithContent:(WeiMiProductCommentDTO *)dto;

- (void)setViewWithDTO:(WeiMiProductCommentDTO *)dto;
@end
