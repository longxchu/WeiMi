//
//  WeiMiSearchBar.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiSearchBar.h"

@interface WeiMiSearchBar()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *searchIcon;
@property (nonatomic, strong) UITextField *searchField;

@end

@implementation WeiMiSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3.0f;
        [self addSubview:self.searchIcon];
        [self addSubview:self.searchField];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - UITextFiled
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchBarTextFieldShouldBeginEditing:)]) {
        __weak typeof(_searchField) ws = _searchField;
        return [self.delegate searchBarTextFieldShouldBeginEditing:ws];
    }
    return false;
}

#pragma mark - Getter
- (UIImageView *)searchIcon
{
    if (!_searchIcon) {
        
        _searchIcon = [[UIImageView alloc] init];
        _searchIcon.image = [UIImage imageNamed:@"icon_serach"];
    }
    return _searchIcon;
}

- (UITextField *)searchField
{
    if (!_searchField) {
        
        _searchField = [[UITextField alloc] init];
        _searchField.placeholder = @"一键搜索,尽享所有";
        _searchField.font = [UIFont systemFontOfSize:14];
        _searchField.borderStyle = UITextBorderStyleNone;
        _searchField.delegate = self;
    }
    return _searchField;
}

#pragma mark - Layout
- (void)updateConstraints
{
    [_searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_searchIcon.mas_right).offset(10);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-10);
    }];
    [super updateConstraints];
}

@end
