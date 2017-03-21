//
//  WeiMiRefundCell.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/18.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableViewCell.h"
#import <UITextView+Placeholder.h>

typedef NS_ENUM(NSInteger, REFUNDCELLTYPE)
{
    REFUNDCELLTYPE_LABELRIGHTBUTTON,//左侧label右侧button
    REFUNDCELLTYPE_TEXTVIEWIGHTBUTTON,//左侧textView右侧button
    REFUNDCELLTYPE_TEXTVIEWONELINE,//只有UITextView，单行textView
    REFUNDCELLTYPE_TEXTVIEWONLY,//只有UITextView
};

typedef void (^ShouldChangeTextHandler) (CGSize);
typedef void (^ShouldBeganEditHandler)();
typedef void (^OnCellHandler)();

@interface WeiMiRefundCell : WeiMiBaseTableViewCell
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *textField;


@property (nonatomic, weak) id <UITextViewDelegate> delegate;

@property (nonatomic, copy) ShouldChangeTextHandler shouldChangeTextHandler;
@property (nonatomic, copy) ShouldBeganEditHandler shouldBeganEditHandler;
@property (nonatomic, copy) OnCellHandler onCellHandler;


- (instancetype)initWithType:(REFUNDCELLTYPE)type reuseIdentifier:(NSString *)reuseIdentifier;

//REFUNDCELLTYPE_LABELRIGHTBUTTON 类型的的高亮处理
- (void)cellOn;
- (void)cellOff;
@end
