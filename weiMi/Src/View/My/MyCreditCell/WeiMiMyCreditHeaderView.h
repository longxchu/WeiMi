//
//  WeiMiMyCreditHeaderView.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

typedef void (^OnIntroBTNHandler) ();
@interface WeiMiMyCreditHeaderView : WeiMiBaseView

@property (nonatomic, copy) OnIntroBTNHandler onIntroBTNHandler;


- (void)setCreditNum:(NSString *)creditNum;

@end
