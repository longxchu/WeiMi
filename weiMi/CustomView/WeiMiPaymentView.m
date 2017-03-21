//
//  WeiMiPaymentView.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/23.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPaymentView.h"

static CGFloat kTitleHeight = 46.0f;
#define PAYMENT_WIDTH [UIScreen mainScreen].bounds.size.width-80
static NSInteger kPwdCount = 6;
static CGFloat kDotWidth = 10.0f;
static CGFloat kKeyBoardHeight = 216.0f;
static CGFloat kKeyViewDistance = 100.0f;
static CGFloat kAlertHeight = 200.0f;


@interface WeiMiPaymentView ()<UITextFieldDelegate>
{
    NSMutableArray *pwdIndicatorArr;
}
@property (nonatomic, strong) UIView *paymentAlert, *inputView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLabel, *line, *detailLabel, *amountLabel;
@property (nonatomic, strong) UITextField *pwdTextField;

@end

@implementation WeiMiPaymentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
        
        [self drawView];
    }
    return self;
}

- (void)drawView {
    if (!_paymentAlert) {
        _paymentAlert = [[UIView alloc]initWithFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height- kKeyBoardHeight -kKeyViewDistance-kAlertHeight, [UIScreen mainScreen].bounds.size.width-80, kAlertHeight)];
        _paymentAlert.layer.cornerRadius = 5.f;
        _paymentAlert.layer.masksToBounds = YES;
        _paymentAlert.backgroundColor = [UIColor colorWithWhite:1. alpha:.95];
        [self addSubview:_paymentAlert];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, PAYMENT_WIDTH, kTitleHeight)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [_paymentAlert addSubview:_titleLabel];
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setFrame:CGRectMake(0, 0, kTitleHeight, kTitleHeight)];
        [_closeBtn setTitle:@"╳" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_paymentAlert addSubview:_closeBtn];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, kTitleHeight, PAYMENT_WIDTH, .5f)];
        _line.backgroundColor = [UIColor lightGrayColor];
        [_paymentAlert addSubview:_line];
        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, kTitleHeight+15, PAYMENT_WIDTH-30, 20)];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = [UIColor darkGrayColor];
        _detailLabel.font = [UIFont systemFontOfSize:16];
        [_paymentAlert addSubview:_detailLabel];
        
        _amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, kTitleHeight*2, PAYMENT_WIDTH-30, 30)];
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        _amountLabel.textColor = [UIColor darkGrayColor];
        _amountLabel.font = [UIFont systemFontOfSize:33];
        [_paymentAlert addSubview:_amountLabel];
        
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(15, _paymentAlert.frame.size.height-(PAYMENT_WIDTH-30)/6-15, PAYMENT_WIDTH-30, (PAYMENT_WIDTH-30)/6)];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.layer.borderWidth = 1.f;
        _inputView.layer.borderColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.].CGColor;
        [_paymentAlert addSubview:_inputView];
        
        pwdIndicatorArr = [[NSMutableArray alloc]init];
        _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pwdTextField.hidden = YES;
        _pwdTextField.delegate = self;
        _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_inputView addSubview:_pwdTextField];
        
        CGFloat width = _inputView.bounds.size.width/kPwdCount;
        for (int i = 0; i < kPwdCount; i ++) {
            UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake((width-kDotWidth)/2.f + i*width, (_inputView.bounds.size.height-kDotWidth)/2.f, kDotWidth, kDotWidth)];
            dot.backgroundColor = [UIColor blackColor];
            dot.layer.cornerRadius = kDotWidth/2.;
            dot.clipsToBounds = YES;
            dot.hidden = YES;
            [_inputView addSubview:dot];
            [pwdIndicatorArr addObject:dot];
            
            if (i == kPwdCount-1) {
                continue;
            }
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width, 0, .5f, _inputView.bounds.size.height)];
            line.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.];
            [_inputView addSubview:line];
        }
    }
    
    
}


- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    _paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
    _paymentAlert.alpha = 0;
    
    
    [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_pwdTextField becomeFirstResponder];
        _paymentAlert.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _paymentAlert.alpha = 1.0;
    } completion:nil];
}

- (void)dismiss {
    [_pwdTextField resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        _paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        _paymentAlert.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length >= kPwdCount && string.length) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
    if (![predicate evaluateWithObject:string]) {
        return NO;
    }
    NSString *totalString;
    if (string.length <= 0) {
        totalString = [textField.text substringToIndex:textField.text.length-1];
    }
    else {
        totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    [self setDotWithCount:totalString.length];
    
    NSLog(@"_____total %@",totalString);
    if (totalString.length == 6) {
        if (_completeHandle) {
            _completeHandle(totalString);
        }
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:.3f];
        NSLog(@"complete");
    }
    
    return YES;
}

- (void)setDotWithCount:(NSInteger)count {
    for (UILabel *dot in pwdIndicatorArr) {
        dot.hidden = YES;
    }
    
    for (int i = 0; i< count; i++) {
        ((UILabel*)[pwdIndicatorArr objectAtIndex:i]).hidden = NO;
    }
}

#pragma mark -
- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        _titleLabel.text = _title;
    }
}

- (void)setDetail:(NSString *)detail {
    if (_detail != detail) {
        _detail = detail;
        _detailLabel.text = _detail;
    }
}

- (void)setAmount:(CGFloat)amount {
    if (_amount != amount) {
        _amount = amount;
        _amountLabel.text = [NSString stringWithFormat:@"￥%.2f",amount];
    }
}


@end
