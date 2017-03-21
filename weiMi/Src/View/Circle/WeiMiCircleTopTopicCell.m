//
//  WeiMiCircleTopTopicCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleTopTopicCell.h"

@interface WeiMiCircleTopTopicCell()

@property (nonatomic, strong) UILabel *tagLB;


@end

@implementation WeiMiCircleTopTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.tagLB];
        [self addSubview:self.titleLB];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (UILabel *)tagLB
{
    if (!_tagLB) {
        
        _tagLB = [[UILabel alloc] init];
        _tagLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        _tagLB.textAlignment = NSTextAlignmentCenter;
        _tagLB.text = @"置顶";
        _tagLB.textColor = kWhiteColor;
        _tagLB.backgroundColor = HEX_RGB(0x68C8FF);
        _tagLB.layer.masksToBounds = YES;
        _tagLB.layer.cornerRadius = 3.0f;
    }
    return _tagLB;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(21)];
        _titleLB.textAlignment = NSTextAlignmentLeft;
        _titleLB.text = @"置顶";
    }
    return _titleLB;
}

- (void)updateConstraints
{
    [_tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(GetAdapterHeight(22));
        make.width.mas_equalTo(_tagLB.mas_height).multipliedBy(2.05f);
    }];
    
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_tagLB.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self);
    }];
    [super updateConstraints];

}

@end
