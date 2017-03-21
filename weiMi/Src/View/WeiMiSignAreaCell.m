//
//  WeiMiSignAreaCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiSignAreaCell.h"
#import "WeiMiSignCollectionViewCell.h"
#import "UIButton+CenterImageAndTitle.h"

static const CGFloat kTitleHeight = 33.0f;
static const CGFloat kMoreBtnHeight = 44.0f;
static NSString *kReuseHeaderID = @"reuseViewHeader";
static NSString *kReuseFooterID = @"reuseViewFooter";
static NSString *kCellID = @"cellID";
#define SEPRATE_LINE_COLOR      (0xeeeeee)
@interface WeiMiSignAreaCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_dataSource;
    NSMutableArray *_imgSource;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation WeiMiSignAreaCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _dataSource = [[NSMutableArray alloc] init];
        _imgSource = [[NSMutableArray alloc] init];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.moreBtn];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.text = @"签到区";
    }
    return _titleLabel;
}

- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.backgroundColor = kWhiteColor;
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moreBtn setTitle:@"戳进更多签到" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:kGrayColor forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"icon_listmore"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //        layout.itemSize = CGSizeMake(self.width/4, self.height/2);
        //        layout.minimumLineSpacing = 0;
        //        layout.minimumInteritemSpacing = 0;
        //        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delaysContentTouches = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[WeiMiSignCollectionViewCell class] forCellWithReuseIdentifier:kCellID];
//        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseHeaderID];
//        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kReuseFooterID];
    }
    return _collectionView;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)button
{
    
}

#pragma mark - Common
- (void)addObjects:(NSArray *)titles images:(NSArray *)images
{
    [_dataSource addObjectsFromArray:titles];
    [_imgSource addObjectsFromArray:images];
    [self.collectionView reloadData];
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_moreBtn horizontalCenterTitleAndImage];
}

- (void)updateConstraints
{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(kTitleHeight);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.bottom.mas_equalTo(_moreBtn.mas_top);
    }];
        
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kMoreBtnHeight);
    }];
    [super updateConstraints];
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
    WeiMiSignCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    return cell;
}

//
//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        UICollectionReusableView *headerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseViewID forIndexPath:indexPath];
//
//        [headerView addSubview:self.titleLabel];
//        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(headerView);
//        }];
//
//        headerView.backgroundColor = kGreenColor;
//        return headerView;
//    }
//    return nil;
//}
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//
//    return CGSizeMake(collectionView.width, 40);
//}

#pragma mark - Delegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(130, 55);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}


@end
