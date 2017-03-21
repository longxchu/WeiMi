//
//  WeiMiActivityCommentBar.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

@interface WeiMiActivityCommentBar : WeiMiBaseView<UITextViewDelegate>

@property (nonatomic, weak) id <UITextViewDelegate> textViewDelegate;

@end
