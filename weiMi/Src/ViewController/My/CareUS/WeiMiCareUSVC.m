//
//  WeiMiCareUSVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/1.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCareUSVC.h"
#import <UIImageView+WebCache.h>
#import "WeiMiGlobalConstants.h"

@interface WeiMiCareUSVC()


@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;

@end

@implementation WeiMiCareUSVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];

    [self.bottomImageView addSubview:self.label1];
    [self.bottomImageView addSubview:self.label2];
    [self.contentView addSubview:self.bottomImageView];
    
//    [_qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:@"https://www.google.com.hk/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0ahUKEwjErqzOnO7OAhWMRo8KHSROADAQjRwIBA&url=%68%74%74%70%3a%2f%2f%77%77%77%2e%6c%69%61%6e%74%75%2e%63%6f%6d%2f&psig=AFQjCNFN-5tXoG_R2TKNWGCbj2rGwCFEdA&ust=1472821186461180"] placeholderImage:[UIImage imageNamed:@"weimiQrCode"]];
//    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.popWithBaseNavColor = YES;
    self.title = @"关于微信";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (UILabel *)label1
{
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        _label1.text = @"唯蜜生活订阅号：weimi_app";
        _label1.textAlignment = UITextBorderStyleLine;
        _label1.textColor =  HEX_RGB(BASE_COLOR_HEX);
        _label1.font = [UIFont systemFontOfSize:15];
//        _label1.image = [UIImage imageNamed:@"qrcode"];
//        _qrCodeImageView.layer.shadowOffset = CGSizeMake(3,2);
//        _qrCodeImageView.layer.shadowOpacity = 0.6;
//        _qrCodeImageView.layer.shadowRadius = 1.0;
//        _qrCodeImageView.clipsToBounds = NO;
    }
    return _label1;
}

- (UILabel *)label2
{
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        _label2.text = @"唯蜜生活服务号：lywm1111";
        _label2.textAlignment = UITextBorderStyleLine;
        _label2.textColor = HEX_RGB(BASE_COLOR_HEX);
       _label2.font = [UIFont systemFontOfSize:15];
    }
    return _label2;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.image = [UIImage imageNamed:@"weibj"];
    }
    return _bottomImageView;
}

#pragma mark - Constraints
- (void)updateViewConstraints
{
    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(GetAdapterHeight(60) + NAV_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 20));
    }];
    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(GetAdapterHeight(100) + NAV_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 20));
    }];

    
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
       make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    }];
    [super updateViewConstraints];
    
}

@end
