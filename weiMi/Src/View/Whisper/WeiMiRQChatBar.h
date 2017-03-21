//
//  WeiMiRQChatBar.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/18.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

typedef void (^OnSendBtnHandler)();

@interface WeiMiRQChatBar : WeiMiBaseView<UITextViewDelegate>

@property (nonatomic, weak) id <UITextViewDelegate> delegate;
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, copy) OnSendBtnHandler onSendBtnHandler;


@end
