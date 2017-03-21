//
//  WeiMiInviteCommentLayout.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "LWLayout.h"
#import "WeiMiInviteCommentStatusModel.h"
#import "WeiMiCommentListResponse.h"

#define MESSAGE_TYPE_IMAGE @"image"
#define MESSAGE_TYPE_WEBSITE @"website"
#define MESSAGE_TYPE_VIDEO @"video"
#define AVATAR_IDENTIFIER @"avatar"

@interface WeiMiInviteCommentLayout : LWLayout

@property (nonatomic,strong) WeiMiCommentListDTO* statusModel;
@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic, assign) CGRect tagRect;

- (id)initWithStatusModel:(WeiMiCommentListDTO *)stautsModel
                    index:(NSInteger)index
            dateFormatter:(NSDateFormatter *)dateFormatter;

@end
