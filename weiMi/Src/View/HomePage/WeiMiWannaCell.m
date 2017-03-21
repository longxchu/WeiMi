//
//  WeiMiWannaCell.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiWannaCell.h"
#import "CycleScrollView.h"
#import "WeiMiWannaItem.h"
#import <UIImageView+WebCache.h>
// ------ request
#import "WeiMiBannerRequest.h"
#import "WeiMiBannerResponse.h"
#import "WeiMiHPProductListRequest.h"
#import "WeiMiHPProductListResponse.h"
#import "WeiMiMaleInvitationRequest.h"
#import "WeiMiMaleInvitationResponse.h"
#import "WeiMiFemaleInvitationRequest.h"
#import "WeiMiFemaleInvitationResponse.h"
//------ DTO
//商品
#import "WeiMiHomePageBannerDTO.h"
//帖子
//#import "WeiMiMFInvitationListDTO.h"


static const CGFloat kTitleHeight = 85/2;
@interface WeiMiWannaCell()
{
    //热卖商品
    WeiMiHPProductListDTO *_hotSellerDTO_1;
    WeiMiHPProductListDTO *_hotSellerDTO_2;
    //帖子
    WeiMiHotCommandDTO *_invitationDTO_1;
    WeiMiHotCommandDTO *_invitationDTO_2;
    
    WeiMiHPWannaDTO *_dto;
}

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) CycleScrollView *cycleScrollView;
@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) WeiMiWannaItem *leftItem;
@property (nonatomic, strong) WeiMiWannaItem *rightItem;
@end

@implementation WeiMiWannaCell

+ (CGFloat)getHeight:(WeiMiHPWannaDTO *)dto
{
//    static WeiMiWannaCell *testCell;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        testCell = [[WeiMiWannaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testCell"];
//    });
    
//    [testCell setViewWithDTO:dto isFresh:NO];
    
//    [testCell setNeedsLayout];
//    [testCell layoutIfNeeded];
    
    return 0.624*SCREEN_WIDTH + SCREEN_WIDTH/2 + 42;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.moreButton];
        [self.contentView addSubview:self.cycleScrollView];
        [self.contentView addSubview:self.leftItem];
        [self.contentView addSubview:self.rightItem];
        
        [self loadAdvert:nil];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiHPWannaDTO *)dto isFresh:(BOOL)isFresh
{
    
    if (!isFresh && ([_dto isEqualToDto:dto] || !dto.navID)) {
        return;
    }
    
    _dto = dto;
    _titleLabel.text = _dto.title;
    
    if ([_dto.navID isEqualToString:@"nans"] || [_dto.navID isEqualToString:@"nvs"]) {
        _leftItem.foreImageView.hidden = YES;
        _rightItem.foreImageView.hidden = YES;
        _leftItem.remarkLB.text = @"暂无帖子";
        _rightItem.remarkLB.text = @"暂无帖子";
        [self getInvitationListIsMale:[_dto.navID isEqualToString:@"nans"]?YES:NO];
        return;
    }
    
    [self getItemBannerWithNavID:_dto.navID];
    [self getHotSllersNavID:_dto.navID];
}


#pragma mark - NetWork
//------ 首页栏目轮播加载
- (void)getItemBannerWithNavID:(NSString *)navID
{
    WeiMiBannerRequest *request = [[WeiMiBannerRequest alloc] initWithIsAble:navID];
    WeiMiBannerResponse *res = [[WeiMiBannerResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [res parseResponse:request.responseJSONObject];
        [self loadAdvert:res.dataArr];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

// -------- 商品列表
- (void)getHotSllersNavID:(NSString *)navID
{
    WeiMiHPProductListRequestModel *model = [[WeiMiHPProductListRequestModel alloc] init];
    model.isAble = @"2";
    model.menuId = navID;
    WeiMiHPProductListRequest *request = [[WeiMiHPProductListRequest alloc] initWithModel:model pageIndex:1 pageSize:2];
    WeiMiHPProductListResponse *res = [[WeiMiHPProductListResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [res parseResponse:request.responseJSONObject];
        //        for (WeiMiHPProductListDTO *dto in res.dataArr) {
        //
        //        }
        if (safeObjectAtIndex(res.dataArr, 0)) {
            _hotSellerDTO_1 = safeObjectAtIndex(res.dataArr, 0);
            [_leftItem setItemWithTitle:_hotSellerDTO_1.productName img:_hotSellerDTO_1.faceImgPath];
        }
        if (safeObjectAtIndex(res.dataArr, 1)) {
            _hotSellerDTO_2 = safeObjectAtIndex(res.dataArr, 1);
            [_rightItem setItemWithTitle:_hotSellerDTO_2.productName img:_hotSellerDTO_2.faceImgPath];
        }

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

//---- 帖子列表 （男生女生）
- (void)getInvitationListIsMale:(BOOL)isMale
{
    WeiMiBaseRequest *request;
    WeiMiMaleInvitationResponse *res = [[WeiMiMaleInvitationResponse alloc] init];
;
    if (isMale) {
        request = [[WeiMiMaleInvitationRequest alloc] initWithIsAble:@"4" pageIndex:1 pageSize:2];
    }else
    {
        request = [[WeiMiFemaleInvitationRequest alloc] initWithIsAble:@"4" pageIndex:1 pageSize:2];
    }

    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [res parseResponse:request.responseJSONObject];
        //        for (WeiMiHPProductListDTO *dto in res.dataArr) {
        //
        //        }
        if (safeObjectAtIndex(res.dataArr, 0)) {
            _invitationDTO_1 = safeObjectAtIndex(res.dataArr, 0);
            [_leftItem setItemWithTitle:_invitationDTO_1.infoTitle img:_invitationDTO_1.imgPath];
        }
        if (safeObjectAtIndex(res.dataArr, 1)) {
            _invitationDTO_2 = safeObjectAtIndex(res.dataArr, 1);
            [_rightItem setItemWithTitle:_invitationDTO_2.infoTitle img:_invitationDTO_2.imgPath];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

//
#pragma mark - Utils
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
        if (!imageUrl) {
            imageview.image = WEIMI_PLACEHOLDER_COMMON;
        }else
        {
            [imageview sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(imageUrl)] placeholderImage:WEIMI_PLACEHOLDER_COMMON];
        }

        return imageview;
    };
    
    self.cycleScrollView.totalPagesCount=^NSInteger(void){
        
        if (!bannerArr.count) {
            return 1;
        }
        return bannerArr.count;
    };
    
    self.cycleScrollView.TapActionBlock=^(NSInteger pageIndex){
        
        SS(strongSelf);
        OnWannCellBannerHandler block = strongSelf.onWannCellBannerHandler;
        if (block) {
            NSString *bannerUrl = ((WeiMiHomePageBannerDTO *)safeObjectAtIndex(bannerArr, pageIndex)).bannerUrl;
            block(bannerUrl ? bannerUrl : @"");
        }
    };
}

#pragma mark - Getter
- (CycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView=[[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GetAdapterHeight(467/2)) animationDuration:4];
        _cycleScrollView.backgroundColor=[UIColor grayColor];
        _cycleScrollView.pageControl.currentPageIndicatorTintColor = HEX_RGB(BASE_COLOR_HEX);
        _cycleScrollView.pageControl.pageIndicatorTintColor = kGrayColor;
    }
    return _cycleScrollView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 42);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.text = @"娘子莫走";
    }
    return _titleLabel;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"icon_more_black"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_moreButton sizeToFit];
    }
    return _moreButton;
}

#pragma mark - Actions
- (void)onButton:(id)sender
{
    if (sender == self.moreButton) {
        OnWannCellMoreBTN block = self.onWannCellMoreBTN;
        if (block) {
            block(_dto.navID, _dto.title);
        }
    }else if (sender == self.leftItem)
    {
        OnWannCellItem4CommunityHandler handler = self.onWannCellItem4CommunityHandler;
        if ([_dto.navID isEqualToString:@"nans"] || [_dto.navID isEqualToString:@"nvs"]) {
            handler(_invitationDTO_1);
            return;
        }
        OnWannCellItem block = self.onWannCellItem;
        if (block) {
            block(_hotSellerDTO_1.productId ? _hotSellerDTO_1.productId:@"");
        }
    }else if (sender == self.rightItem)
    {
        OnWannCellItem4CommunityHandler handler = self.onWannCellItem4CommunityHandler;
        if ([_dto.navID isEqualToString:@"nans"] || [_dto.navID isEqualToString:@"nvs"]) {
            handler(_invitationDTO_2);
            return;
        }
        OnWannCellItem block = self.onWannCellItem;
        if (block) {
            block(_hotSellerDTO_2.productId ? _hotSellerDTO_2.productId:@"");
        }
    }

    //    WeiMiTryOutGroundVC *vc = [[WeiMiTryOutGroundVC alloc] init];
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.];
    //    UPRouterOptions *options = [UPRouterOptions routerOptions];
    //    options.hidesBottomBarWhenPushed = YES;
    //    [[WeiMiPageSkipManager homeRouter] intoVC:@"WeiMiTryOutGroundVC" options:options];
}

- (WeiMiWannaItem *)leftItem
{
    if (!_leftItem) {
        _leftItem = [[WeiMiWannaItem alloc] init];
        [_leftItem addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftItem;
}

- (WeiMiWannaItem *)rightItem
{
    if (!_rightItem) {
        _rightItem = [[WeiMiWannaItem alloc] init];
        [_rightItem addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightItem;
}

- (void)updateConstraints
{
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(_titleLabel);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.height.mas_equalTo(_cycleScrollView.mas_width).multipliedBy(0.624);
    }];
    
    [@[_leftItem, _rightItem] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [@[_leftItem, _rightItem] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_cycleScrollView.mas_bottom);
        make.height.mas_equalTo(_leftItem.mas_width).priorityHigh();
//        make.bottom.mas_equalTo(0).priorityHigh();
    }];
    [super updateConstraints];
}

@end
