//
//  WeiMiRefundCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/18.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRefundCell.h"
#import "WeiMiBaseView.h"


@interface WeiMiRefundCell()<UITextViewDelegate, UITextFieldDelegate>
{
    REFUNDCELLTYPE _cellType;
}

@property (nonatomic, strong) WeiMiBaseView *bgView;
@property (nonatomic, strong) UIButton *rightBTN;
@property (nonatomic, strong) UIButton *fullBTN;


@end

@implementation WeiMiRefundCell

- (instancetype)initWithType:(REFUNDCELLTYPE)type reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellType = type;
        self.textLabel.font = WeiMiSystemFontWithpx(22);
        [self addSubview:self.bgView];
        [self sendSubviewToBack:_bgView];
        
        switch (type) {
            case REFUNDCELLTYPE_LABELRIGHTBUTTON:
            {
                [self.bgView addSubview:self.rightBTN];
                [self.rightBTN setHidden:YES];
                [self addSubview:self.fullBTN];
            }
                break;
            case REFUNDCELLTYPE_TEXTVIEWIGHTBUTTON:
            {
                [self addSubview:self.textView];
                _textField.userInteractionEnabled = NO;
                _textView.userInteractionEnabled = NO;
                [self.bgView addSubview:self.rightBTN];
                _textView.scrollEnabled  = NO;
//                [self addSubview:self.fullBTN];
            }
                break;
            case REFUNDCELLTYPE_TEXTVIEWONELINE:
            {
                [self addSubview:self.textField];
//                _textView.scrollEnabled  = YES;
//                _textView.userInteractionEnabled = NO;
            }
                break;
            case REFUNDCELLTYPE_TEXTVIEWONLY:
            {
                [self addSubview:self.textView];
            }
                break;
            default:
                break;
        }
        
        [self setNeedsUpdateConstraints];
//        [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

#pragma mark - SEtter
- (void)setDelegate:(id<UITextViewDelegate>)delegate
{
    _delegate = delegate;
    _textView.delegate = _delegate;
}

#pragma mark -Getter
- (WeiMiBaseView *)bgView
{
    if (!_bgView) {
        _bgView = [[WeiMiBaseView alloc] init];
        _bgView.backgroundColor = kWhiteColor;
        _bgView.layer.borderColor = kGrayColor.CGColor;
        _bgView.layer.borderWidth = 0.5f;
    }
    return _bgView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = WeiMiSystemFontWithpx(22);
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.delegate = self;
    }
    return _textField;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = WeiMiSystemFontWithpx(22);

    }
    return _textView;
}
- (UIButton *)rightBTN
{
    if (!_rightBTN) {
        _rightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBTN.titleLabel.font = [UIFont systemFontOfSize:14];
        _rightBTN.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightBTN setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_rightBTN setTitleColor:kGrayColor forState:UIControlStateSelected];
        if (_cellType == REFUNDCELLTYPE_TEXTVIEWIGHTBUTTON) {
            [_rightBTN setImage:[UIImage imageNamed:@"icon_downArrow"] forState:UIControlStateNormal];
            [_rightBTN setImage:[UIImage imageNamed:@"icon_downArrow"] forState:UIControlStateSelected];
        }else
        {
            [_rightBTN setImage:[UIImage imageNamed:@"icon_ball_pre"] forState:UIControlStateNormal];
            [_rightBTN setImage:[UIImage imageNamed:@"icon_ball_pre"] forState:UIControlStateSelected];
        }
        [_rightBTN sizeToFit];
        [_rightBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBTN;
}

- (UIButton *)fullBTN
{
    if (!_fullBTN) {
        _fullBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullBTN;
}

#pragma mark - Util
- (NSMutableAttributedString *)configOffPrice:(NSString *)str
{
    return [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)}];
}

#pragma mark - Actions
- (void)cellOn;
{
    _fullBTN.selected = YES;
    if (_cellType == REFUNDCELLTYPE_LABELRIGHTBUTTON) {
        _rightBTN.hidden = !_fullBTN.selected;
        self.textLabel.textColor = _fullBTN.selected ? kRedColor : kBlackColor;
    }
}
- (void)cellOff
{
    _fullBTN.selected = NO;
    if (_cellType == REFUNDCELLTYPE_LABELRIGHTBUTTON) {
        _rightBTN.hidden = !_fullBTN.selected;
        self.textLabel.textColor = _fullBTN.selected ? kRedColor : kBlackColor;
    }
}
- (void)onButton:(UIButton *)sender
{
    if (sender == self.fullBTN) {
        sender.selected = !sender.selected;
        if (_cellType == REFUNDCELLTYPE_LABELRIGHTBUTTON) {
            _rightBTN.hidden = !sender.selected;
            self.textLabel.textColor = sender.selected ? kRedColor : kBlackColor;
        }

    }
    
    OnCellHandler hander = self.onCellHandler;
    if (hander) {
        hander();
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
//    ShouldChangeTextHandler block = self.shouldChangeTextHandler;
//    if (block) {
//        block(textView.contentSize);
//    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
//    if ([_textView isFirstResponder]) {
//        ShouldBeganEditHandler block = self.shouldBeganEditHandler;
//        if (block) {
//            block();
//        }
//    }
    return YES;
}

#pragma mark - KVO
//-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
//                        change:(NSDictionary *)change context:(void *)context
//{
//    id _oldValue = [change objectForKey:NSKeyValueChangeOldKey];
//    id _newValue = [change objectForKey:NSKeyValueChangeNewKey];
//    
//    if (![_newValue isEqual:_oldValue])
//    {
//        _rightBTN.selected = (BOOL)_newValue;
//    }
//}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];

}

- (void)updateConstraints
{
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    if (_rightBTN) {
        [_rightBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(-10);
        }];
    }

    if (_fullBTN) {
        [_fullBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(self);
        }];
    }

    if (_textView) {
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self);
            if (_rightBTN) {
                make.width.mas_equalTo(self).multipliedBy(0.75);
            }else
            {
                make.right.mas_equalTo(_bgView.mas_right).offset(-5);
            }
            
            make.height.mas_equalTo(self).offset(-6);
        }];
    }
    
    if (_textField) {
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(_bgView.mas_right).offset(-5);

        }];
    }

    [super updateConstraints];
}

- (void)dealloc
{
//    [self removeObserver:self forKeyPath:@"highlighted"];
}

@end
