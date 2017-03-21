//
//  WeiMiExchangeDetailVC.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/21.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiExchangeDetailVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiChitExchangeCell.h"
//#import "UILabel+AlignTop.h"
#import "WeiMITopLeftAlignLabel.h"

@interface WeiMiExchangeDetailVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    NSArray *_imgArr;
}
@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UIImageView *tableHeader;
@property (nonatomic, strong) WeiMITopLeftAlignLabel *notiLabel;

@end

@implementation WeiMiExchangeDetailVC

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

    [self.view setNeedsUpdateConstraints];
    
    
    //填充View
    #warning 兑换记录没有详情
//    [_tableHeader sd_setImageWithURL:[NSURL URLWithString:_dto.imgURL] placeholderImage:WEIMI_IMAGENAMED(@"banner")];
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
    self.title = @"兑换详情";
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
#warning 兑换记录没有详情
//    cell.titleLabel.text = _dto.title;
//    cell.subTitleLabel.text = [NSString stringWithFormat:@"%@趣币", _dto.vouPrice];
    
    cell.rightLabel.text = @"已结束";
    
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
        make.bottom.mas_equalTo(0);
    }];

    [super updateViewConstraints];
}


@end
