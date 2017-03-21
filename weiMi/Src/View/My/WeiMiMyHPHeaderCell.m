//
//  WeiMiMyHPHeaderCell.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyHPHeaderCell.h"
#import "UIColor+WeiMiUIColor.h"
#import <UIButton+WebCache.h>
#import <Masonry.h>

#define TEXT_COLOR          (0x302F2F)
@interface WeiMiMyHPHeaderCell()
{
    
}

@property (nonatomic, strong) UIButton *headBtn;

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation WeiMiMyHPHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.loginBtn];
        [self.contentView addSubview:self.registerBtn];
        [self.contentView addSubview:self.headBtn];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.sexualLabel];

        [self setNeedsUpdateConstraints];
        
        [self changeToLogined:NO];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiUserInfoDTO *)dto
{
    if (self.isLogin) {
        
//        [self.headBtn setImage:[UIImage imageWithData:dto.headImage] forState:UIControlStateNormal];
        [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:dto.avaterPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"face"]];
        self.nameLabel.text = dto.userName == nil ? @"用户" : dto.userName;
//        self.sexualLabel.text = [dto.gender isEqualToString:@"male"] ? @"男":@"女";
        self.sexualLabel.text = dto.gender;
    }
}

#pragma mark -Setter
- (void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    [self changeToLogined:isLogin];
}

- (void)changeToLogined:(BOOL)logined
{
    [self.headBtn setHidden:!logined];
    [self.nameLabel setHidden:!logined];
    [self.sexualLabel setHidden:!logined];
    [self.loginBtn setHidden:logined];
    [self.registerBtn setHidden:logined];
}

#pragma mark - Getter
- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.borderColor = HEX_RGB(BASE_COLOR_HEX).CGColor;
        _loginBtn.layer.borderWidth = 1.0f;
        _loginBtn.layer.cornerRadius = 3.0f;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
//        [_loginBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
//        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_guanzhu"] forState:UIControlStateNormal];
//        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_loginBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)registerBtn
{
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.borderColor = HEX_RGB(BASE_COLOR_HEX).CGColor;
        _registerBtn.layer.borderWidth = 1.0f;
        _registerBtn.layer.cornerRadius = 3.0f;
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
//        [_registerBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
        //        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_guanzhu"] forState:UIControlStateNormal];
//        [_registerBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_registerBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

- (UIButton *)headBtn
{
    if (!_headBtn) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headBtn setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        [_headBtn setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateHighlighted];
        [_headBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headBtn;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = HEX_RGB(TEXT_COLOR);
        _nameLabel.text = @"用户";
    }
    return _nameLabel;
}

- (UILabel *)sexualLabel
{
    if (!_sexualLabel) {
        _sexualLabel = [[UILabel alloc] init];
        _sexualLabel.font = [UIFont systemFontOfSize:16];
        _sexualLabel.textColor = HEX_RGB(BASE_COLOR_HEX);
        _sexualLabel.text = @"男";
    }
    return _sexualLabel;
}

#pragma mark - Actions
- (void)onBtn:(UIButton *)button
{
    if (button != _headBtn) {
        button.selected = !button.selected;
    }
    OnClickButtonHandler block = self.onClickButtonHandler;
    if (block) {
        if (button == self.loginBtn) {
            
            block(HEADERBUTTONTYPE_LOGIN);
        }else if (button == self.registerBtn)
        {
            block(HEADERBUTTONTYPE_REGISTER);
        }
    }
}


#pragma mark - layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.layer.cornerRadius = self.headBtn.width/2;
}

- (void)updateConstraints
{
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(32);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(_headBtn.mas_height);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.5);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_headBtn.mas_right).offset(12);
        make.top.mas_equalTo(_headBtn);
        make.right.mas_equalTo(-20);
    }];
    
    [_sexualLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_nameLabel);
        make.bottom.mas_equalTo(_headBtn);
        make.right.mas_equalTo(-20);
    }];
    
    [@[_loginBtn, _registerBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(GetAdapterHeight(70), GetAdapterHeight(32)));
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self).offset(-self.width/6);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self).offset(self.width/6);
    }];
                              
    [super updateConstraints];
}

@end
