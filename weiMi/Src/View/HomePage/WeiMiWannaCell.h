//
//  WeiMiWannaCell.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import "WeiMiHPWannaDTO.h"
#import "WeiMiMFInvitationListDTO.h"
#import "WeiMiHotCommandDTO.h"

typedef void (^OnWannCellMoreBTN)(NSString *, NSString *);
typedef void (^OnWannCellItem)(NSString *);
typedef void (^OnWannCellItem4CommunityHandler) (id);
typedef void (^OnWannCellBannerHandler)(NSString *);
@interface WeiMiWannaCell : WeiMiBaseTableViewCell

@property (nonatomic, copy) OnWannCellMoreBTN onWannCellMoreBTN;
@property (nonatomic, copy) OnWannCellItem onWannCellItem;
@property (nonatomic, copy) OnWannCellItem4CommunityHandler onWannCellItem4CommunityHandler;
@property (nonatomic, copy) OnWannCellBannerHandler onWannCellBannerHandler;

+ (CGFloat)getHeight:(WeiMiHPWannaDTO *)dto;

- (void)setViewWithDTO:(WeiMiHPWannaDTO *)dto isFresh:(BOOL)isFresh;

@end
