//
//  WeiMiCommentListResponse.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseResponse.h"

@interface WeiMiCommentListDiscussModel : WeiMiBaseDTO

@property (nonatomic, strong) NSString *createTime;//新增时间
@property (nonatomic, strong) NSString *dianzan;//圈子id
@property (nonatomic, strong) NSString *disContent;//infoId
@property (nonatomic, strong) NSString *disId;//type
@property (nonatomic, strong) NSString *isAble;//content
@property (nonatomic, strong) NSString *memberId;//content
@property (nonatomic, strong) NSString *memberName;//content
@property (nonatomic, strong) NSString *infoId;//content
@property (nonatomic, strong) NSString *headImgPath;//content

//--------- 自定义
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, assign) BOOL isLike;
@end

@interface WeiMiCommentListReplayModel : WeiMiBaseDTO

@property (nonatomic, strong) NSString *tomemberId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *disId;
@property (nonatomic, strong) NSString *isAble;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *detId;
@property (nonatomic, strong) NSString *memberName;
@property (nonatomic, strong) NSString *detContent;
@property (nonatomic, assign) NSInteger index;
@end

@interface WeiMiCommentListDTO : WeiMiBaseDTO

@property (nonatomic, strong) WeiMiCommentListDiscussModel *model;
@property (nonatomic, strong) NSMutableArray *commentArr;

@end

@interface WeiMiCommentListResponse : WeiMiBaseResponse

@property (nonatomic, strong)NSMutableArray *dataArr;

@end
