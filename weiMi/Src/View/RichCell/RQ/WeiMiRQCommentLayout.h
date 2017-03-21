//
//  WeiMiRQCommentLayout.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "LWLayout.h"
#import "WeiMiRQCommentModel.h"

#define AVATAR_IDENTIFIER @"avatar"


@interface WeiMiRQCommentLayout : LWLayout

@property (nonatomic,strong) WeiMiRQCommentModel* statusModel;
@property (nonatomic,assign) CGFloat cellHeight;

- (id)initWithStatusModel:(WeiMiRQCommentModel *)stautsModel
                    index:(NSInteger)index
            dateFormatter:(NSDateFormatter *)dateFormatter;
@end
