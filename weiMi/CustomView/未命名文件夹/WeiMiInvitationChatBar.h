//
//  WeiMiInvitationChatBar.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"
#import <UITextView+Placeholder.h>

typedef void (^OnZanBtnHandler)();
typedef void (^OnLoveBtnHandler)(UIButton *);
typedef void (^OnCommentBtnHandler)();
@interface WeiMiInvitationChatBar : WeiMiBaseView<UITextViewDelegate>

@property (nonatomic, copy) OnZanBtnHandler onZanBtnHandler;
@property (nonatomic, copy) OnLoveBtnHandler onLoveHandler;
@property (nonatomic, copy) OnCommentBtnHandler onCommentHandler;
@property (nonatomic, weak) id <UITextViewDelegate> delegate;

@property (nonatomic, strong) UITextView *inputTextView;

@end
