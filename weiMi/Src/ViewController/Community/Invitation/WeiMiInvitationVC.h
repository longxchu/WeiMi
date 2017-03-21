//
//  WeiMiInvitationVC.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseViewController.h"
#import "WeiMiHotCommandDTO.h"

@interface WeiMiInvitationVC : WeiMiBaseViewController

@property (nonatomic, strong) WeiMiHotCommandDTO *dto;
@property (nonatomic, strong) NSString *infoId;
@property (nonatomic, assign) BOOL isFromMRtiyan;

@end
