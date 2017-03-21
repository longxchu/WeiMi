//
//  WeiMiPurchaseGoodsVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPurchaseGoodsVC.h"
#import "CycleScrollView.h"
#import "WeiMiPurchaseGoodCell.h"
#import <UIImageView+WebCache.h>
#import "WeiMiGoodStyleCell.h"
//------- R&&Q
#import "WeiMiBannerRequest.h"
#import "WeiMiBannerResponse.h"
#import "WeiMiAddPurchaseChartRequest.h"

//------- DTO
#import "WeiMiHomePageBannerDTO.h"

#import "UICollectionViewLeftAlignedLayout.h"
#import "WeiMiPurchaseGoodsHeader.h"

#define SCROOLVIEW_BGCOLOR (0xEAEAEA)
static NSString *kCellID = @"cellID";
static NSString *kHeader = @"headerID";
#define BTN_BORDER_COLOR    (0xCFCFCF)


@interface WeiMiPurchaseGoodsVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_dataSource;
    NSUInteger _num;
    CGSize _collectionViewSize;
    
    NSString *_selectedProperty;
    
    BOOL _needRemarkConstriant;
}

@property (nonatomic, strong) UIScrollView *scrollBGView;
@property (nonatomic,strong) CycleScrollView *cycleScrollView;
@property (nonatomic, strong) WeiMiPurchaseGoodCell *goodCell;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) WeiMiBaseView *buyAmountBGView;
@property (nonatomic, strong) UIButton *plusBtn;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UILabel *tagLabel;

@property (nonatomic, strong) UIButton *addAddressBtn;

@end

@implementation WeiMiPurchaseGoodsVC

- (instancetype)init
{
    if (self = [super init]) {
        _num = 1;
        _dataSource = [NSMutableArray new];
        _needRemarkConstriant = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买详情";

    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:YES];
    CGRect frame = self.contentFrame;

    [self.contentView addSubview:self.scrollBGView];
    _scrollBGView.frame = frame;
    
    [_scrollBGView addSubview:self.cycleScrollView];
    [_scrollBGView addSubview:self.goodCell];
    [_scrollBGView addSubview:self.collectionView];

    [_scrollBGView addSubview:self.buyAmountBGView];
    [_buyAmountBGView addSubview:self.minusBtn];
    [_buyAmountBGView addSubview:self.numLabel];
    [_buyAmountBGView addSubview:self.plusBtn];
    [_buyAmountBGView addSubview:self.tagLabel];
    
    [self.contentView addSubview:self.addAddressBtn];
    
    [self.view setNeedsUpdateConstraints];
    
    [self configData];
}

- (void)configData
{
    [self getBanner];
    [_goodCell setGoodPrice:_response.dto.price img:_response.dto.faceImgPath];
    _dataSource = [NSMutableArray arrayWithArray:_response.property];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 10);


    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)initNavgationItem
{
    [super initNavgationItem];

    
//    self.popWithBaseNavColor = YES;
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
}



#pragma mark - Getter
- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        //        _textLabel.textColor = [UIColor colorWithWhite:0.294 alpha:1.000];
        _tagLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
//        _tagLabel.backgroundColor = [UIColor yellowColor];

        _tagLabel.text= @"购买数量";
        [_tagLabel sizeToFit];
    }
    return _tagLabel;
}
- (UIButton *)minusBtn
{
    if (!_minusBtn) {
        _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusBtn setImage:[UIImage imageNamed:@"icon_less"] forState:UIControlStateNormal];
        [_minusBtn setImage:[UIImage imageNamed:@"icon_less"] forState:UIControlStateSelected];
        [_minusBtn addTarget:self action:@selector(onCellBtn:) forControlEvents:UIControlEventTouchUpInside];
//        _minusBtn.backgroundColor = [UIColor orangeColor];
        _minusBtn.layer.masksToBounds = YES;
        _minusBtn.layer.borderColor = HEX_RGB(BTN_BORDER_COLOR).CGColor;
        _minusBtn.layer.borderWidth = 1.0f;
    }
    return _minusBtn;
}

- (UIButton *)plusBtn
{
    if (!_plusBtn) {
        _plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusBtn setImage:[UIImage imageNamed:@"icon_more-1"] forState:UIControlStateNormal];
        [_plusBtn setImage:[UIImage imageNamed:@"icon_more-1"] forState:UIControlStateSelected];
        [_plusBtn addTarget:self action:@selector(onCellBtn:) forControlEvents:UIControlEventTouchUpInside];
        _plusBtn.layer.masksToBounds = YES;
//        _plusBtn.backgroundColor = [UIColor blueColor];

        _plusBtn.layer.borderColor = HEX_RGB(BTN_BORDER_COLOR).CGColor;
        _plusBtn.layer.borderWidth = 1.0f;
    }
    return _plusBtn;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)_num];
        _numLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(24)];
        _numLabel.layer.masksToBounds = YES;
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.layer.borderColor = HEX_RGB(BTN_BORDER_COLOR).CGColor;
        _numLabel.layer.borderWidth = 1.0f;
//        _numLabel.backgroundColor = [UIColor purpleColor];

    }
    return _numLabel;
}

- (WeiMiBaseView *)buyAmountBGView
{
    if (!_buyAmountBGView) {
        
        _buyAmountBGView = [[WeiMiBaseView alloc] init];
        _buyAmountBGView.backgroundColor = kWhiteColor; //kWhiteColor;
    }
    return _buyAmountBGView;
}

- (UIButton *)addAddressBtn
{
    if (!_addAddressBtn) {
        
        _addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        //        _addAddressBtn.layer.masksToBounds = YES;
        //
        //        _addAddressBtn.layer.cornerRadius = 3.0f;
        [_addAddressBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_addAddressBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_addAddressBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateNormal];
        [_addAddressBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_addAddressBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addAddressBtn;
}
- (UIScrollView *)scrollBGView
{
    if (!_scrollBGView) {
        _scrollBGView = [[UIScrollView alloc] init];
        _scrollBGView.showsVerticalScrollIndicator = NO;
        _scrollBGView.showsHorizontalScrollIndicator = NO;
        _scrollBGView.scrollEnabled = YES;
//        _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
        _scrollBGView.backgroundColor = HEX_RGB(SCROOLVIEW_BGCOLOR);
    }
    return _scrollBGView;
}
- (CycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView=[[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GetAdapterHeight(320)) animationDuration:4];
        _cycleScrollView.backgroundColor=[UIColor grayColor];
        _cycleScrollView.pageControl.currentPageIndicatorTintColor = kClearColor;
        _cycleScrollView.pageControl.pageIndicatorTintColor = kClearColor;
    }
    return _cycleScrollView;
}

- (WeiMiPurchaseGoodCell *)goodCell
{
    if (!_goodCell) {
        _goodCell = [[WeiMiPurchaseGoodCell alloc] init];
    }
    return _goodCell;
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        CGFloat width = (SCREEN_WIDTH - 53)/2;
//        layout.itemSize = CGSizeMake(width, width * (82.0/330));
        layout.minimumLineSpacing = 13;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 45);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delaysContentTouches = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[WeiMiGoodStyleCell class] forCellWithReuseIdentifier:kCellID];
        [_collectionView registerClass:[WeiMiPurchaseGoodsHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeader];
    }
    return _collectionView;
}

#pragma mark - NetWork
//--- 加入购物车
- (void)addChart:(WeiMiAddPurchaseChartModel *)model
{
    
    WeiMiAddPurchaseChartRequest *request = [[WeiMiAddPurchaseChartRequest alloc] initWithModel:model];
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request)
     {
         SS(strongSelf);
         NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
         if ([result isEqualToString:@"1"]) {
             [strongSelf presentSheet:@"加入购物车成功" complete:^{
                 [strongSelf BackToLastNavi];
             }];
         }else
         {
             [strongSelf presentSheet:@"加入购物车失败"];
         }
         
     } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
         
         //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
     }];
}


- (void)getBanner
{
    if (_response) {
        [self loadAdvert:@[_response.dto.faceImgPath]];
    }
}
/**
 *  图片轮播
 */
-(void)loadAdvert:(NSArray *)bannerArr
{
    WS(weakSelf);
    
    self.cycleScrollView.fetchContentViewAtIndex=^UIView *(NSInteger pageIndex){
        
        NSString *imageUrl = safeObjectAtIndex(bannerArr, pageIndex);
        UIImageView *imageview = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, weakSelf.cycleScrollView.width, weakSelf.cycleScrollView.height)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(imageUrl)] placeholderImage:WEIMI_PLACEHOLDER_COMMON];
        return imageview;
    };
    
    self.cycleScrollView.totalPagesCount=^NSInteger(void){
        return bannerArr.count;
    };
    
    self.cycleScrollView.TapActionBlock=^(NSInteger pageIndex){
        
    };
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    if (_isBuy) {
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager homeRouter] intoVC:@"WeiMiMakeSureOrderVC" options:options];
    }else//加入购物车
    {
        if (!_selectedProperty) {
            [self presentSheet:@"请选择商品种类"];
            return;
        }
        WeiMiAddPurchaseChartModel *model = [[WeiMiAddPurchaseChartModel alloc] init];
        model.productName = _response.dto.productName;
        model.productType = _response.dto.proTypeId;
        model.productBrand = _response.dto.brandId;
        model.productImg = _response.dto.faceImgPath;
        model.price = _response.dto.price;
        model.number = _numLabel.text;
        model.property = _selectedProperty;
        model.memberId = [WeiMiUserCenter sharedInstance].userInfoDTO.tel;
        model.productId = _response.dto.productId;
        model.isAble = @"1";

        [self addChart:model];
    }

}

#pragma mark - Actions
- (void)onCellBtn:(UIButton *)button
{

    if (button == self.plusBtn)
    {
        NSInteger num = _numLabel.text.integerValue;
        _num = num + 1;
        _numLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_num ];
        [_goodCell setPrice:[NSString stringWithFormat:@"%.2f", _num * _response.dto.price.floatValue]];
        [self.buyAmountBGView setNeedsLayout];

    }else if (button == self.minusBtn)
    {
        NSInteger num = _numLabel.text.integerValue;
        if (num == 1) {
            _numLabel.text = @"1";
            _num = 1;
        }else{
             _num = num - 1;
            _numLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_num];
           
        }
        [_goodCell setPrice:[NSString stringWithFormat:@"%.2f", _num * _response.dto.price.floatValue]];
        [self.buyAmountBGView setNeedsLayout];
    }
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WeiMiGoodStyleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
//    NSInteger height = collectionView.collectionViewLayout.collectionViewContentSize.height;
//    [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(_goodCell.mas_bottom).offset(1);
//        make.width.mas_equalTo(_goodCell);
//        make.height.mas_equalTo(height);
//    }];
    [cell.btn setTitle:safeObjectAtIndex(_dataSource, indexPath.row) forState:UIControlStateNormal];

    return cell;
}
#pragma mark - Delegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedProperty = safeObjectAtIndex(_dataSource, indexPath.row);
    [_goodCell setGoodProperty:_selectedProperty];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        WeiMiPurchaseGoodsHeader * view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeader forIndexPath:indexPath];
        reusableview = view;
    }
    return reusableview;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH - 53)/2;
    NSString *str = safeObjectAtIndex(_dataSource, indexPath.row);
    CGSize size = [str returnSize:WeiMiSystemFontWithpx(20) MaxWidth:SCREEN_HEIGHT];
    width = size.width;
    return  CGSizeMake(width + 10, GetAdapterHeight(45));
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}


#pragma mark - layout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    NSInteger height = _collectionView.collectionViewLayout.collectionViewContentSize.height;
//    _collectionView.size = CGSizeMake(SCREEN_WIDTH, height);
    
    if (height > 0 && _needRemarkConstriant) {
        _needRemarkConstriant = NO;
        
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(_goodCell.mas_bottom).offset(1);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(height);
        }];
//        dispatch_once_t onceToken;
//        WS(weakSelf);
//        ONCE_GCD(onceToken, ^(){
//            SS(strongSelf);
//           
//        });
        _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, _buyAmountBGView.bottom > SCREEN_HEIGHT ? _buyAmountBGView.bottom  - NAV_HEIGHT: SCREEN_HEIGHT + 10);//10
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)updateViewConstraints {
//    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.mas_equalTo(0);
//        make.width.mas_equalTo(SCREEN_WIDTH);
//        make.height.mas_equalTo(GetAdapterHeight(330/2));
//    }];
    [_goodCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(_cycleScrollView.mas_bottom);
        make.height.mas_equalTo(@110);
    }];
    

//    NSInteger height = _collectionView.collectionViewLayout.collectionViewContentSize.height;
//    _collectionView.size = CGSizeMake(SCREEN_WIDTH, 200);
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_goodCell.mas_bottom).offset(1);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(209);
    }];
    
    [_buyAmountBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_collectionView);
        make.top.mas_equalTo(_collectionView.mas_bottom).offset(0.5);
        make.height.mas_equalTo(75);
        make.width.mas_equalTo(self.view.frame.size.width);
    }];
    
    [_minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(_plusBtn);
        make.centerY.mas_equalTo(_plusBtn);
        make.right.mas_equalTo(_numLabel.mas_left);
//         make.left.mas_equalTo(_numLabel).offset(400);
    }];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(_plusBtn);
        make.right.mas_equalTo(_plusBtn.mas_left);
        make.height.mas_equalTo(_plusBtn);
        make.width.mas_equalTo(_numLabel.mas_height).multipliedBy(1.55);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(_buyAmountBGView);
    }];
    
    [_plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_buyAmountBGView);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(_plusBtn.mas_height).multipliedBy(1.16);
    }];
    
    [_addAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-5);
        make.height.mas_equalTo(40);
    }];
    
    [super updateViewConstraints];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (BOOL)prefersStatusBarHidden
//{
//    return NO; // 返回NO表示要显示，返回YES将不显示
//}

@end
