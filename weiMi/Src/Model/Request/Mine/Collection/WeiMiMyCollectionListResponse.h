//
//  WeiMiMyCollectionListResponse.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseResponse.h"
#import "WeiMiGoodsDTO.h"
#import "WeiMiMFInvitationListDTO.h"
@interface WeiMiMyCollectionListResponse : WeiMiBaseResponse

@property (nonatomic, strong) NSMutableArray *dataArr;

-(void)parseResponse:(NSDictionary *)dic isGoods:(BOOL)isGoods;
@end
