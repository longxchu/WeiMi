//
//  WeiMiCircleCell.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiMiCircleLayout.h"
#import "Gallop.h"

@interface WeiMiCircleCell : UITableViewCell

@property (nonatomic,strong) WeiMiCircleLayout* cellLayout;
@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic, strong) UIButton *zanBTN;//点赞
@property (nonatomic, strong) UIButton *commentBTN;//评论

@property (nonatomic,copy) void(^clickedAvatarCallback)(UITableViewCell* cell);
@end
