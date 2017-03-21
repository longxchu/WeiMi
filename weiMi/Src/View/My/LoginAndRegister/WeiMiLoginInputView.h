//
//  WeiMiLoginInputView.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

@interface WeiMiLoginInputView : WeiMiBaseView<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputFiled;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL secureTextEntry;
//@property (nonatomic, strong) NSString *contentText;

@property (nonatomic, weak) id <UITextFieldDelegate> delegate;

@end
