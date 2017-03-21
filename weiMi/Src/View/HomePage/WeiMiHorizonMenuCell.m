//
//  WeiMiHorizonMenuCell.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHorizonMenuCell.h"
#import "WeiMiHorizonMenuItem.h"
#import "WeiMiTryOutGroundVC.h"

static const CGFloat kTitleHeight = 96/2;
static NSString *kReuseViewID = @"reuseViewID";
static NSString *kCellID = @"cellID";
@interface WeiMiHorizonMenuCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_dataSource;
    NSMutableArray *_imgSource;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation WeiMiHorizonMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _dataSource = [[NSMutableArray alloc] init];
        _imgSource = [[NSMutableArray alloc] init];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.moreButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.text = @"美人体验";
    }
    return _titleLabel;
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
        [_collectionView registerClass:[WeiMiHorizonMenuItem class] forCellWithReuseIdentifier:kCellID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseViewID];
    }
    return _collectionView;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"icon_more_black"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton sizeToFit];
    }
    return _moreButton;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    
    OnMoreBTN block = self.onMoreBTN;
    if (block) {
        block();
    }
//    WeiMiTryOutGroundVC *vc = [[WeiMiTryOutGroundVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.];
//    UPRouterOptions *options = [UPRouterOptions routerOptions];
//    options.hidesBottomBarWhenPushed = YES;
//    [[WeiMiPageSkipManager homeRouter] intoVC:@"WeiMiTryOutGroundVC" options:options];
}
#pragma mark - Common
- (void)addObjects:(NSArray *)titles images:(NSArray *)images
{
    [_dataSource addObjectsFromArray:titles];
    [_imgSource addObjectsFromArray:images];
    [self.collectionView reloadData];
}

#pragma mark - Layout
- (void)updateConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(96/2);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
    }];
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(_titleLabel);
        
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
    WeiMiHorizonMenuItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    [cell setViewWithTitle:_dataSource[indexPath.item] img:_imgSource[indexPath.item]];
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
    OnItem block = self.onItem;
    if (block) {
        block(indexPath.row);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

@end
