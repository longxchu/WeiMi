//
//  WeiMiAddressDetailVC.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseViewController.h"


@class WeiMiRecAddDTO;
typedef void (^CallBackHandler)(WeiMiRecAddDTO *);

@interface WeiMiAddressDetailVC : WeiMiBaseViewController

@property (nonatomic, strong) CallBackHandler callBackHandler;

@end
