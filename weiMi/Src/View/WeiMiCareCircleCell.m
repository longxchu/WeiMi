//
//  WeiMiCareCircleCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCareCircleCell.h"
#import "WeiMiSignCollectionViewCell.h"
#import "UIButton+CenterImageAndTitle.h"

static NSString *kAddBtnID = @"addBtnID";
static NSString *kCellID = @"cellID";
#define SEPRATE_LINE_COLOR      (0xeeeeee)
const CGFloat myCareItemHeight = 55.0f;
const CGFloat myCareTitleHeight = 33.0f;

@interface WeiMiCareCircleCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_dataSource;
    NSMutableArray *_imgSource;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation WeiMiCareCircleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _listArr = [[NSMutableArray alloc] init];
        _dataSource = [[NSMutableArray alloc] init];
        _imgSource = [[NSMutableArray alloc] init];
        [_dataSource addObject:@"add"];
        [_imgSource addObject:@"add"];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.collectionView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (UIButton *)addBtn
{
    if (!_addBtn) {
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.backgroundColor = kWhiteColor;
        _addBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addBtn setTitle:@"关注新圈子" forState:UIControlStateNormal];
        [_addBtn setTitleColor:kGrayColor forState:UIControlStateNormal];
        [_addBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.text = @"我关注的";
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0,5, 0, 5);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delaysContentTouches = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[WeiMiSignCollectionViewCell class] forCellWithReuseIdentifier:kCellID];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kAddBtnID];
    }
    return _collectionView;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)button
{
    OnAddNewCareBlock block = self.onAddNewCareBlock;
    if (block) {
        block();
    }
}

#pragma mark - Common
- (void)addObject:(NSString *)title image:(NSString *)image;
{
    [_dataSource addObject:title];
    [_imgSource addObject:image];
    [self.collectionView reloadData];
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.addBtn horizontalCenterTitleAndImageLeft:6];
}

- (void)updateConstraints
{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(myCareTitleHeight);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [super updateConstraints];
}
- (void)setListArr:(NSMutableArray *)listArr {
    _listArr = [NSMutableArray arrayWithArray:listArr];
    [self.collectionView reloadData];
}
#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count + _listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _listArr.count) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAddBtnID forIndexPath:indexPath];
        [cell.contentView addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        return cell;
    }
    
    WeiMiSignCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    WeiMiCircleCateListDTO *model = _listArr[indexPath.row];
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(model.ringIcon)] placeholderImage:WEIMI_PLACEHOLDER_COMMON];
    cell.titleLabel.text = model.ringTitle;
    
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
    if(indexPath.item < _listArr.count ){
        WeiMiCircleCateListDTO *dto = _listArr[indexPath.item];
        WeiMiCircleDetailVC *vc = [[WeiMiCircleDetailVC alloc] init];
        vc.dto = dto;
        vc.hidesBottomBarWhenPushed = YES;
        vc.popWithBaseNavColor = YES;
        [[self superVC].navigationController pushViewController:vc animated:YES];
    }
}
- (UIViewController*)superVC {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-10)/3, myCareItemHeight);
}



@end
