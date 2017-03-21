//
//  WeiMiCommentInputView.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

typedef void (^OnAddPicBtnHandler)();
typedef void (^OnSwitchHandler)(UISwitch *);
@interface WeiMiCommentInputView : WeiMiBaseView

@property (nonatomic, copy) OnAddPicBtnHandler onAddPicBtnHandler;
@property (nonatomic, copy) OnSwitchHandler onSwitchHandler;

@end
