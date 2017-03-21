//
//  WeiMiApplyDetailVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiApplyDetailVC.h"
#import "CycleScrollView.h"
#import <UIImageView+WebCache.h>
#import "WeiMiApplyIntroView.h"
#import "WeiMiTryOutInfoView.h"
#import "DateUtil.h"
#import "DDConvertTimeStamp.h"
//------- R&&Q
#import "WeiMiBannerRequest.h"
#import "WeiMiBannerResponse.h"
//------- DTO
#import "WeiMiHomePageBannerDTO.h"

@interface WeiMiApplyDetailVC ()

@property (nonatomic, strong) UIScrollView *scrollBGView;
@property (nonatomic,strong) CycleScrollView *cycleScrollView;//轮播
@property (nonatomic, strong) UILabel *titleLB;//商品名

@property (nonatomic, strong) WeiMiTryOutInfoView *infoView;

@property (nonatomic, strong) UILabel *downTimeLB;//倒计时

@property (nonatomic, strong) WeiMiApplyIntroView *introView;

@property (nonatomic, strong) UILabel *detailLB;//物品详情

@property (nonatomic, strong) UIButton *addAddressBtn;


@end

@implementation WeiMiApplyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:YES];
    
    [self.contentView addSubview:self.scrollBGView];
    _scrollBGView.frame = self.contentFrame;

    //scrollView添加视图
    [_scrollBGView addSubview:self.cycleScrollView];
    [_scrollBGView addSubview:self.titleLB];
     [_scrollBGView addSubview:self.infoView];
    [_scrollBGView addSubview:self.downTimeLB];
    [_scrollBGView addSubview:self.introView];
    [_scrollBGView addSubview:self.detailLB];

    [self.view addSubview:self.addAddressBtn];
    [self.view setNeedsUpdateConstraints];
//    [self getBanner];
    
    [self configData:self.dto];
}

- (void)configData:(WeiMiTryoutListDTO *)dto
{
    _titleLB.text = dto.applyName;
    BOOL isEnd = YES;
    
    if (dto.endTime) {
        NSDate *date = [DateUtil getDateFromStringWithDefaultFormat:dto.endTime];
        NSDate *currentDate = [NSDate date];
        double diff = [DateUtil timeDiff:DVM_SECOND beginTime:date endTime:currentDate];
        if (diff > 0.0000001) {//未截止
            isEnd = NO;
        }
    }

    [_infoView setViewWithPrice:dto.applyPrice applyNum:[NSString stringWithFormat:@"%ld", dto.numPerson] goodNum:[NSString stringWithFormat:@"%ld", dto.applyNumber]  status:isEnd ? @"已截止":@"申请中"];
    _detailLB.attributedText = [self attWith:[NSString stringWithFormat:@"品牌：%@\n商品：%@\n材质：%@\n颜色：%@", dto.applyBrand, dto.applyTitle, dto.applyCz, dto.applyColor]];
    
    WeiMiHomePageBannerDTO *bannerDto = [[WeiMiHomePageBannerDTO alloc] init];
    bannerDto.bannerImgPath = dto.applyImg;
    [self loadAdvert:@[bannerDto]];
    
    _downTimeLB.text = [NSString stringWithFormat:@"截止时间：%@", dto.endTime];
    
    if (isEnd) {
        _addAddressBtn.userInteractionEnabled = NO;
        [_addAddressBtn setTitle:@"已截止" forState:UIControlStateNormal];
        [_addAddressBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_addAddressBtn setBackgroundColor:kGrayColor];
        _addAddressBtn.layer.cornerRadius = 3.0f;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"申请详情";
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
- (UIScrollView *)scrollBGView
{
    if (!_scrollBGView) {
        _scrollBGView = [[UIScrollView alloc] init];
        _scrollBGView.showsVerticalScrollIndicator = NO;
        _scrollBGView.showsHorizontalScrollIndicator = NO;
        _scrollBGView.scrollEnabled = YES;
        //        _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    }
    return _scrollBGView;
}

- (CycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView=[[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GetAdapterHeight(322)) animationDuration:4];
        _cycleScrollView.backgroundColor= [UIColor grayColor];
        _cycleScrollView.pageControl.currentPageIndicatorTintColor = HEX_RGB(BASE_COLOR_HEX);
        _cycleScrollView.pageControl.pageIndicatorTintColor = kGrayColor;
    }
    return _cycleScrollView;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _titleLB.textAlignment = NSTextAlignmentLeft;
        _titleLB.numberOfLines = 0;
        _titleLB.text = @"卡特玲那二代 伸缩旋转 全自动飞机杯紫薇器";
    }
    return _titleLB;
}

- (WeiMiTryOutInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[WeiMiTryOutInfoView alloc] init];
    }
    return _infoView;
}

- (UILabel *)downTimeLB
{
    if (!_downTimeLB) {
        _downTimeLB = [[UILabel alloc] init];
        _downTimeLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _downTimeLB.textAlignment = NSTextAlignmentCenter;
        _downTimeLB.numberOfLines = 0;
        _downTimeLB.text = @"距离结束：01天19小时17分钟45秒";
    }
    return _downTimeLB;

}

- (WeiMiApplyIntroView *)introView
{
    if (!_introView) {
        _introView = [[WeiMiApplyIntroView alloc] init];
    }
    return _introView;
}

- (UILabel *)detailLB
{
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
        _detailLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _detailLB.textAlignment = NSTextAlignmentLeft;
        _detailLB.numberOfLines = 0;
        _detailLB.attributedText = [self attWith:@"品牌：\n商品：\n材质：\n颜色："];
    }
    return _detailLB;
}

- (UIButton *)addAddressBtn
{
    if (!_addAddressBtn) {
        
        _addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        //        _addAddressBtn.layer.masksToBounds = YES;
        //
        //        _addAddressBtn.layer.cornerRadius = 3.0f;
        [_addAddressBtn setTitle:@"立即申请" forState:UIControlStateNormal];
        [_addAddressBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_addAddressBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateNormal];
        [_addAddressBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_addAddressBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addAddressBtn;
}

#pragma mark - Actiosn
- (void)onButton:(UIButton *)sender
{
    [[WeiMiPageSkipManager homeRT] open:@"WeiMiApplyContentVC"];
}
#pragma mark - NetWork
- (void)getBanner
{
    WeiMiBannerRequest *request = [[WeiMiBannerRequest alloc] init];
    WeiMiBannerResponse *res = [[WeiMiBannerResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [res parseResponse:request.responseJSONObject];
        [self loadAdvert:res.dataArr];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}
/**
 *  图片轮播
 */
-(void)loadAdvert:(NSArray *)bannerArr
{
    WS(weakSelf);
    
    self.cycleScrollView.fetchContentViewAtIndex=^UIView *(NSInteger pageIndex){
        
        NSString *imageUrl = ((WeiMiHomePageBannerDTO *)safeObjectAtIndex(bannerArr, pageIndex)).bannerImgPath;
        UIImageView *imageview = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, weakSelf.cycleScrollView.width, weakSelf.cycleScrollView.height)];
        //        imageview.image = [UIImage imageNamed:@"followus_bg480x800"];
        NSString *str = WEIMI_IMAGEREMOTEURL(imageUrl);
        [imageview sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:WEIMI_PLACEHOLDER_COMMON];
        return imageview;
    };
    
    self.cycleScrollView.totalPagesCount=^NSInteger(void){
        return bannerArr.count;
    };
    
    self.cycleScrollView.TapActionBlock=^(NSInteger pageIndex){
        
    };
}

#pragma mark - Utils
- (NSAttributedString *)attWith:(NSString*)string{
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 30.0f;
    
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:style}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - layout
- (void)viewDidLayoutSubviews
{
    
    _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, _detailLB.bottom + 10);
    
    [super viewDidLayoutSubviews];
}

- (void)updateViewConstraints
{
    [_addAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_scrollBGView).offset(10);
        make.right.mas_equalTo(_cycleScrollView).offset(-10);

        make.top.mas_equalTo(_cycleScrollView.mas_bottom).offset(10);
    }];
    
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_titleLB);
        make.height.mas_equalTo(105);
        make.top.mas_equalTo(_titleLB.mas_bottom).offset(10);
    }];
    
    [_downTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_titleLB);
        make.top.mas_equalTo(_infoView.mas_bottom).offset(10);
    }];
    
    [_introView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_downTimeLB.mas_bottom).offset(10);
        make.left.right.mas_equalTo(_titleLB);
//        make.height.mas_equalTo(200);
    }];
    
    [_detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_titleLB);
        make.top.mas_equalTo(_introView.mas_bottom).offset(20);
    }];
    
    [super updateViewConstraints];
}

@end
