//
//  HPWealListModel.h
//  weiMi
//
//  Created by zhaoke on 2016/12/15.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiMiBaseRequest.h"

@interface HPWealListModel : WeiMiBaseDTO

@property (nonatomic, copy) NSString *isAble;
@property (nonatomic, copy) NSString *aboutContext;
@property (nonatomic, copy) NSString *aboutTitle;
@property (nonatomic, copy) NSString *aboutId;
@property (nonatomic, copy) NSString *aboutType;

@end

@interface HPWealListRequest : WeiMiBaseRequest

@end

@interface HPWealListResponse : WeiMiBaseResponse

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@interface HPMRtiyanModel : WeiMiBaseDTO

@property (nonatomic, copy) NSString *mrId;
@property (nonatomic, copy) NSString *infoId;
@property (nonatomic, copy) NSString *inforTitile;
@property (nonatomic, copy) NSString *inforImg;
@property (nonatomic, copy) NSString *isAble;

@end

@interface HPMRtiyanRequest : WeiMiBaseRequest

@end

@interface HPMRtiyanResponse : WeiMiBaseResponse

@property (nonatomic, strong) NSMutableArray *dataArr;

@end
