//
//  WeiMiCircleLayout.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "LWLayout.h"
#import "WeiMiHotCommandDTO.h"


@interface WeiMiCircleLayout : LWLayout

@property (nonatomic,strong) WeiMiHotCommandDTO* statusModel;//数据源
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGRect lineRect;
@property (nonatomic,assign) CGRect dateRect;
@property (nonatomic,assign) CGRect avatarPosition;


- (id)initWithStatusModel:(WeiMiHotCommandDTO *)stautsModel
                    index:(NSInteger)index
            dateFormatter:(NSDateFormatter *)dateFormatter;

@end
