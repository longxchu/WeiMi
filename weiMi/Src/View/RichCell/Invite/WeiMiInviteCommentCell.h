//
//  WeiMiInviteCommentCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiInviteCommentLayout.h"
#import "Gallop.h"

@interface WeiMiInviteCommentCell : WeiMiBaseTableViewCell

@property (nonatomic,strong) WeiMiInviteCommentLayout* cellLayout;
@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,copy) void(^clickedZanButtonCallback)(WeiMiInviteCommentCell* cell,UIButton *zanBtn);
@property (nonatomic,copy) void(^clickedAvatarCallback)(WeiMiInviteCommentCell* cell);
@property (nonatomic,copy) void(^clickedReCommentCallback)(WeiMiInviteCommentCell* cell,WeiMiCommentListReplayModel* model);
@property (nonatomic,copy) void(^clickedCommentButtonCallback)(WeiMiInviteCommentCell* cell);


@end
