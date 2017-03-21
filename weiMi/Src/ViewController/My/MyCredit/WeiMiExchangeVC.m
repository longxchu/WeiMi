//
//  WeiMiExchangeVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiExchangeVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiChitExchangeCell.h"
//#import "UILabel+AlignTop.h"
#import "WeiMITopLeftAlignLabel.h"
#import <OHAlertView.h>
#import <UIImageView+WebCache.h>

#import "WeiMiExchangeResultVC.h"
//------ request
#import "WeiMiCreditToExchangeRequest.h"

@interface WeiMiExchangeVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    NSArray *_imgArr;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UIImageView *tableHeader;
@property (nonatomic, strong) WeiMITopLeftAlignLabel *notiLabel;
@property (nonatomic, strong) UIButton *exchangeBTN;

@end

@implementation WeiMiExchangeVC


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dataSource = @[@"在线客服"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    _tableView.frame = self.contentFrame;
    _tableView.tableHeaderView = self.tableHeader;
    _tableView.tableFooterView = self.notiLabel;
    [self.contentView addSubview:self.exchangeBTN];
    [self.view setNeedsUpdateConstraints];
    
    
    //填充View
    [_tableHeader sd_setImageWithURL:[NSURL URLWithString:_dto.imgURL] placeholderImage:WEIMI_IMAGENAMED(@"banner")];
    
    self.title = [_dto.vouType isEqualToString:@"1"] ? @"代金券兑换" : @"商品兑换";
    
    self.exchangeBTN.selected = [_dto.vouEnd isEqualToString:@"0"]? YES:NO;
    self.exchangeBTN.userInteractionEnabled = [_dto.vouEnd isEqualToString:@"0"]? NO:YES;
    
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
    self.title = @"代金券兑换";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (UIImageView *)tableHeader
{
    if (!_tableHeader) {
        _tableHeader = [[UIImageView alloc] init];
        _tableHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 175);
        _tableHeader.image = [UIImage imageNamed:@"banner"];
    }
    return _tableHeader;
}

- (UILabel *)notiLabel
{
    if (!_notiLabel) {
        
        _notiLabel = [[WeiMITopLeftAlignLabel alloc] init];
        _notiLabel.backgroundColor = kWhiteColor;
        _notiLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
        _notiLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
        _notiLabel.textAlignment = NSTextAlignmentLeft;
        _notiLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _notiLabel.numberOfLines = 0;
        _notiLabel.attributedText = [self attrTitle:@"活动规则\n" string:@"·使用范围：每笔订单现用一张优惠券，全场通用礼券，此券不挂失，不合并，不招聘，不兑换现金。\n·通过非法途径获得积分后进行正常的兑换行为，商家不提供服务\n·本次兑换不得以任何方式作为二次销售，一经发现将对其追究法律责任。\n·客服热线：400-975-976"];
    }
    return _notiLabel;
}

- (UIButton *)exchangeBTN
{
    if (!_exchangeBTN) {
        
        _exchangeBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _exchangeBTN.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        //        _addAddressBtn.layer.masksToBounds = YES;
        //
        //        _addAddressBtn.layer.cornerRadius = 3.0f;
        [_exchangeBTN setTitle:@"马上兑换" forState:UIControlStateNormal];
        [_exchangeBTN setTitle:@"已结束" forState:UIControlStateSelected];
        [_exchangeBTN setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _exchangeBTN.layer.cornerRadius = 3.0f;
        _exchangeBTN.layer.masksToBounds = YES;
        [_exchangeBTN setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateNormal];
        [_exchangeBTN setBackgroundImage:[UIImage imageWithColor:kGrayColor] forState:UIControlStateSelected];
        [_exchangeBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeBTN;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.backgroundColor = kWhiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

#pragma mark - Utils
- (NSAttributedString *)attrTitle:(NSString *)title string:(NSString *)content
{
    //设置缩进
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 10;
    style.paragraphSpacing = 5;
    style.lineBreakMode = NSLineBreakByTruncatingMiddle;
    style.headIndent = 10;//左缩进
    style.tailIndent = 0;//右缩进
    style.lineSpacing = 8.0f;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kFontSizeWithpx(23)],
                                                NSParagraphStyleAttributeName:style
                                                  } range:NSMakeRange(0,title.length)];
    NSMutableAttributedString *suffStr = [[NSMutableAttributedString alloc] initWithString:content];
    [suffStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,content.length)];
    [suffStr addAttribute:NSForegroundColorAttributeName value:kGrayColor range:NSMakeRange(0,content.length)];
    [attrStr appendAttributedString:suffStr];
    return attrStr;
}

#pragma mark - Network
//---- 兑换积分
- (void)getExchangeWithMemberId:(NSString *)memberId vouId:(NSString *)vouId
{
    WeiMiCreditToExchangeRequest *request = [[WeiMiCreditToExchangeRequest alloc] initWithMemberId:memberId vouId:vouId];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSString *resutlStr = EncodeStringFromDic(result, @"result");
        if ([resutlStr isEqualToString:@"success"]) {//兑换成功
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
//            [[WeiMiPageSkipManager mineRouter] skipIntoVC:@"WeiMiExchangeResultVC"];
            WeiMiExchangeResultVC *vc = [[WeiMiExchangeResultVC alloc] init];
            vc.dto = _dto;
            [self.navigationController pushViewController:vc animated:YES];
        }else//兑换失败
        {
            [strongSelf presentSheet:resutlStr];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

#pragma mark - Actions
- (void)onButton:(UIButton *)button
{
    if (_currentCredit < _dto.vouPrice.integerValue) {
        
        [self presentSheet:@"啊哦，积分不足"];
        return;
    }
    
    WS(weakSelf);
    [OHAlertView showAlertWithTitle:[NSString stringWithFormat:@"确定使用%@趣币兑换？", _dto.vouPrice] message:@"兑换成功后将自动为您充值" cancelButton:@"取消" otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            SS(strongSelf);
            [strongSelf getExchangeWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel vouId:_dto.vouId];

        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    WeiMiChitExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMiChitExchangeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.titleLabel.text = _dto.title;
    cell.subTitleLabel.text = [NSString stringWithFormat:@"%@积分", _dto.vouPrice];
    cell.rightLabel.text = [_dto.vouEnd isEqualToString:@"0"]? @"已结束":@"抢兑中";
    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Constraints
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)updateViewConstraints
{
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(NAV_HEIGHT + STATUS_BAR_HEIGHT);
        make.bottom.mas_equalTo(_exchangeBTN.mas_top).offset(-10);
    }];
    
    [_exchangeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    
    [super updateViewConstraints];
}


@end
