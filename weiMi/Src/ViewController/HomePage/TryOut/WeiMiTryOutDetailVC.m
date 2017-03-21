//
//  WeiMiTryOutDetailVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTryOutDetailVC.h"
#import "UIImageView+WebCache.h"

//----- request
#import "WeiMiTryoutGroundDetailRequest.h"
#import "WeiMiTryoutGroundDetailResponse.h"


@interface WeiMiTryOutDetailVC ()


@property (nonatomic, strong) UIScrollView *scrollBGView;

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *titleLB;

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *headerLB;

@property (nonatomic, strong) UILabel *detailLB;//评分详情
@property (nonatomic, strong) UILabel *introContentLB;//评测详情


@end

@implementation WeiMiTryOutDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.scrollBGView];
    _scrollBGView.frame = self.contentFrame;
//    _scrollBGView.backgroundColor = kGrayColor;
    
    [_scrollBGView addSubview:self.topImageView];
    [_scrollBGView addSubview:self.titleLB];
    
    [_scrollBGView addSubview:self.headerImageView];
    [_scrollBGView addSubview:self.headerLB];

    [_scrollBGView addSubview:self.detailLB];
    [_scrollBGView addSubview:self.introContentLB];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getDetail];
}

- (void)initNavgationItem{
    [super initNavgationItem];
    self.title = @"评测详情";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        //        if (_saveName) {
        //            [[WeiMiPageSkipManager mineRouter] callBackToVC:@"WeiMiModifyNameVC" params:@[_name]];
        //        }
        [strongSelf BackToLastNavi];
    }];
}
#pragma mark - Getter
- (UIScrollView *)scrollBGView{
    if (!_scrollBGView) {
        _scrollBGView = [[UIScrollView alloc] init];
        _scrollBGView.showsVerticalScrollIndicator = NO;
        _scrollBGView.showsHorizontalScrollIndicator = NO;
        _scrollBGView.scrollEnabled = YES;
        //        _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    }
    return _scrollBGView;
}
- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(26)];
        _titleLB.textAlignment = NSTextAlignmentLeft;
        _titleLB.numberOfLines = 0;
        _titleLB.text = @"女票说我买了一个小三";
    }
    return _titleLB;
}
- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.layer.masksToBounds = YES;
//        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:TEST_IMAGE_URL] placeholderImage:[UIImage imageNamed:@"weimiQrCode"]];
        _headerImageView.image = WEIMI_PLACEHOLDER_RECT;
    }
    return _headerImageView;
}
- (UIImageView *)topImageView{
    if (!_topImageView) {
        
        _topImageView = [[UIImageView alloc] init];
//        [_topImageView sd_setImageWithURL:[NSURL URLWithString:TEST_IMAGE_URL] placeholderImage:[UIImage imageNamed:@"weimiQrCode"]];
        _topImageView.image = WEIMI_PLACEHOLDER_RECT;
    }
    return _topImageView;
}
- (UILabel *)headerLB{
    if (!_headerLB) {
        
        _headerLB = [[UILabel alloc] init];
        _headerLB.font = WeiMiSystemFontWithpx(20);
        _headerLB.textAlignment = NSTextAlignmentLeft;
        _headerLB.textColor = kGrayColor;
        _headerLB.numberOfLines = 2;
        _headerLB.text = @"用户甲";
    }
    return _headerLB;
}
- (UILabel *)detailLB{
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
        _detailLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _detailLB.textAlignment = NSTextAlignmentLeft;
        _detailLB.numberOfLines = 0;
        _detailLB.attributedText = [self attWith:@"品牌：艾莱特\n商品：卡特玲那二代\n材质：高级橡胶，金属\n颜色：香槟金"];
    }
    return _detailLB;
}

- (UILabel *)introContentLB
{
    if (!_introContentLB) {
        
        _introContentLB = [[UILabel alloc] init];
        _introContentLB.font = WeiMiSystemFontWithpx(22);
        _introContentLB.textAlignment = NSTextAlignmentLeft;
//        _introContentLB.textColor = kGrayColor;
        _introContentLB.numberOfLines = 0;
        _introContentLB.text = @"Google 文档提供了智能化的编辑和样式工具，可让您轻松地设置文字和段落的格式，从而制作生动的文档。有数百种字体可供选择，您还可以添加链接、图片和绘图。一切功能完全免费！只要有手机、平板电脑或计算机，您就能随时随地访问、创建和编辑文档，即使没有联网也不受影响。";
    }
    return _introContentLB;
}
- (CGFloat)calculateRealHeightWithStr:(NSString *)str {
    return [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:WeiMiSystemFontWithpx(22)} context:nil].size.height;
}
#pragma mark - Network
//---- 评测详情
- (void)getDetail
{
    WeiMiTryoutGroundDetailRequest *request = [[WeiMiTryoutGroundDetailRequest alloc] initWithIDStr:self.idString];
    WeiMiTryoutGroundDetailResponse *response = [[WeiMiTryoutGroundDetailResponse alloc] init];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSLog(@"--z %@",request.responseJSONObject);
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (result) {
            [response parseResponse:result];
            [strongSelf configData:response.dto];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}


#pragma mark - Utils
- (void)configData:(WeiMiTryoutGroundDetailDTO *)dto
{
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.applyImg)] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.headImgPath)] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    NSString *splitStr = [NSString stringWithFormat:@"品牌：%@\n商品：%@\n材质：%@，金属\n颜色：%@",dto.applyBrand,dto.applyName,dto.applyCz,dto.applyColor];
    _headerLB.text = dto.memberName;
    _detailLB.attributedText = [self attWith:splitStr];
    _introContentLB.text = dto.content;
    //SCREEN_WIDTH - 30
    CGFloat realHeight = [self calculateRealHeightWithStr:dto.content]+15;
    _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH-30)*2+realHeight);
    
}

- (NSAttributedString *)attWith:(NSString*)string{
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5.0f;
    
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:style}];
}

#pragma mark - layout
- (void)viewDidLayoutSubviews
{
    
    _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, _introContentLB.bottom > SCREEN_HEIGHT ? _introContentLB.bottom +10 : SCREEN_HEIGHT + 10);
    _headerImageView.layer.cornerRadius = _headerImageView.width/2;

    [super viewDidLayoutSubviews];
}

- (void)updateViewConstraints
{
    [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_scrollBGView);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
        make.height.mas_equalTo(_topImageView.mas_width);
    }];
    
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(SCREEN_WIDTH - 20);
        make.top.mas_equalTo(_topImageView.mas_bottom).offset(20);
    }];
    
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLB);
        make.top.mas_equalTo(_titleLB.mas_bottom).offset(10);
        make.width.mas_equalTo(GetAdapterHeight(35));
        make.height.mas_equalTo(_headerImageView.mas_width);

    }];
    
    [_headerLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_titleLB);
        make.centerY.mas_equalTo(_headerImageView);
        make.left.mas_equalTo(_headerImageView.mas_right).offset(10);
    }];
    
    [_detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_titleLB);
        make.top.mas_equalTo(_headerImageView.mas_bottom).offset(20);

    }];
    
    [_introContentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.left.right.mas_equalTo(_titleLB);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
        make.top.mas_equalTo(_detailLB.mas_bottom).offset(20);
    }];
    [super updateViewConstraints];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
