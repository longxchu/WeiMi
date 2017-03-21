//
//  WeiMiTryoutCollectionCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/1.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTryoutCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface WeiMiTryoutCollectionCell()
{
//    NSUInteger _buyNum;
//    NSUInteger _applyNum;

}

@property (nonatomic, strong) UIImageView *cellImage;
@property (nonatomic, strong) UILabel *tagLB;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *infoLB;

@end

@implementation WeiMiTryoutCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.cellImage];
        [self addSubview:self.tagLB];
        [self addSubview:self.titleLB];
        [self addSubview:self.infoLB];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiTryoutListDTO *)dto
{
    [_cellImage sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.applyImg)] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    _titleLB.text = dto.applyName;
    _infoLB.attributedText = [self attrStrWithBuyNum:dto.applyNumber applyNum:dto.numPerson];
}

#pragma mark - Getter
- (UIImageView *)cellImage
{
    if (!_cellImage) {
        
        _cellImage = [[UIImageView alloc] init];
        _cellImage.image =WEIMI_PLACEHOLDER_RECT;
    }
    return _cellImage;
}

- (UILabel *)tagLB
{
    if (!_tagLB) {
        
        _tagLB = [[UILabel alloc] init];
        _tagLB.textAlignment = NSTextAlignmentCenter;
        _tagLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(18)];
        _tagLB.textColor = kWhiteColor;
        _tagLB.backgroundColor = HEX_RGB(0x71CA3C);
        _tagLB.text = @"申请中";
    }
    return _tagLB;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        
        _titleLB = [[UILabel alloc] init];
        _titleLB.textAlignment = NSTextAlignmentLeft;
        _titleLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _titleLB.numberOfLines = 2;
        _titleLB.text = @"秘籍 夜魅精灵女用萨达是发顺丰";
        [_titleLB sizeToFit];
    }
    return _titleLB;
}

- (UILabel *)infoLB
{
    if (!_infoLB) {
        
        _infoLB = [[UILabel alloc] init];
        _infoLB.textAlignment = NSTextAlignmentLeft;
        _infoLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        _infoLB.numberOfLines = 2;
        _infoLB.textColor = kGrayColor;
        _infoLB.attributedText = [self attrStrWithBuyNum:0 applyNum:0];
        [_infoLB sizeToFit];
    }
    return _infoLB;
}

#pragma mark - utils
- (NSMutableAttributedString *)attrStrWithBuyNum:(NSUInteger)buyNum applyNum:(NSUInteger)applyNum
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"数量:"];
    NSAttributedString *sufStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n", (unsigned long)buyNum] attributes:@{
                                                                                                                                           NSFontAttributeName:[UIFont boldSystemFontOfSize:kFontSizeWithpx(20)], NSForegroundColorAttributeName:kRedColor}];
    [attString appendAttributedString:sufStr];
    
    sufStr = [[NSAttributedString alloc] initWithString:@"申请人数:" attributes:@{
                                                    NSFontAttributeName:[UIFont systemFontOfSize:kFontSizeWithpx(20)]}];
    [attString appendAttributedString:sufStr];
    sufStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (unsigned long)applyNum] attributes:@{
                                                                                                                                                   NSFontAttributeName:[UIFont boldSystemFontOfSize:kFontSizeWithpx(20)], NSForegroundColorAttributeName:kRedColor}];
    [attString appendAttributedString:sufStr];
    
    return attString;
}

#pragma mark - Layout
- (void)updateConstraints
{
    [_cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(_cellImage.mas_width);
    }];
    
    [_tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(_cellImage);
        make.height.mas_equalTo(GetAdapterHeight(30));
        make.width.mas_equalTo(_tagLB.mas_height).multipliedBy(1.87f);
    }];
    
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_cellImage);
        make.top.mas_equalTo(_cellImage.mas_bottom).offset(10);
    }];
    
    [_infoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_titleLB);
        make.bottom.mas_equalTo(self);
    }];
    [super updateConstraints];
}
@end
