//
//  WeiMiRQCommentCell.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiRQCommentLayout.h"

@interface WeiMiRQCommentCell : WeiMiBaseTableViewCell

@property (nonatomic,strong) WeiMiRQCommentLayout* cellLayout;
@property (nonatomic,strong) NSIndexPath* indexPath;

@end
