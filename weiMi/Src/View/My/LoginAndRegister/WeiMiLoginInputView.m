//
//  WeiMiLoginInputView.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiLoginInputView.h"

@interface WeiMiLoginInputView()

@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation WeiMiLoginInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
//        [self addSubview:self.titleLabel];
        [self addSubview:self.inputFiled];
        [self setNeedsUpdateConstraints];
        self.backgroundColor = kWhiteColor;
    }
    return self;
}

#pragma mark -Setter
- (void)setTitle:(NSString *)title
{
    _inputFiled.placeholder = title;
//    _title = title;
//    _titleLabel.text = title;
//    [_titleLabel sizeToFit];
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    _delegate = delegate;
    if ([self.delegate conformsToProtocol:@protocol(UITextFieldDelegate) ]) {
        _inputFiled.delegate = self.delegate;
    }
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    _inputFiled.keyboardType = keyboardType;
}

#pragma mark - Getter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0, 0, 40, self.height);
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.textAlignment = NSTextAlignmentLeft;

        _titleLabel.text = @"手机号";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UITextField *)inputFiled
{
    if (!_inputFiled) {
        
        _inputFiled = [[UITextField alloc] init];
        _inputFiled.font = [UIFont fontWithName:@"Arial" size:14];
        _inputFiled.placeholder = nil;
        _inputFiled.textAlignment = NSTextAlignmentLeft;
        _inputFiled.keyboardType = UIKeyboardTypePhonePad;
        _inputFiled.borderStyle = UITextBorderStyleNone;
        _inputFiled.placeholder = @"手机号";
    }
    return _inputFiled;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    _secureTextEntry = secureTextEntry;
    [_inputFiled setSecureTextEntry:secureTextEntry];
}


#pragma mark - Layout
- (void)updateConstraints
{
    [_inputFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self);
    }];
    
    [super updateConstraints];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat LineHeight = 1.0f;
    CGPoint start = CGPointMake(0, rect.size.height);
    CGPoint end = CGPointMake(rect.size.width, rect.size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddLineToPoint(context, end.x, end.y);
    //设置颜色和线条宽度
    CGContextSetLineWidth(context, LineHeight);
    CGContextSetStrokeColorWithColor(context, HEX_RGB(BASE_COLOR_HEX).CGColor);
    //渲染
    CGContextStrokePath(context);
}

@end
