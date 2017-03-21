//
//  WeiMiPaymentView.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/23.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

@interface WeiMiPaymentView : WeiMiBaseView

@property (nonatomic, copy) NSString *title, *detail;
@property (nonatomic, assign) CGFloat amount;

@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

- (void)show;

@end
