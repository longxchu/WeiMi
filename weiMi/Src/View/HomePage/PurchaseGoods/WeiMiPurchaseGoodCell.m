//
//  WeiMiPurchaseGoodCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/30.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPurchaseGoodCell.h"
#import <UIImageView+WebCache.h>
#import <OHAttributedStringAdditions.h>
@interface WeiMiPurchaseGoodCell()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *priceLB;
@property (nonatomic, strong) UILabel *goodsPorpertyLB;

@end

@implementation WeiMiPurchaseGoodCell

- (instancetype)init {
    self = [super init];
    if(self){
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.cellImageView];
        [self addSubview:self.priceLB];
        [self addSubview:self.goodsPorpertyLB];
        [self setNeedsUpdateConstraints];
    }
    return self;
}
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//    }
//    return self;
//}
- (void)setPrice:(NSString *)price {
    _priceLB.text = [NSString stringWithFormat:@"¥%@", price];
}
- (void)setGoodProperty:(NSString *)str {
    _goodsPorpertyLB.text = [NSString stringWithFormat:@"已选：%@", str];
}
- (void)setGoodPrice:(NSString *)price img:(NSString *)img {
    _priceLB.text = [NSString stringWithFormat:@"¥%@", price];
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(img)] placeholderImage:WEIMI_PLACEHOLDER_RECT];
}

#pragma mark - Getter
- (UIImageView *)cellImageView {
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.image = WEIMI_PLACEHOLDER_RECT;
    }
    return _cellImageView;
}
- (UILabel *)priceLB {
    if (!_priceLB) {
        _priceLB = [[UILabel alloc] init];
        _priceLB.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFontSizeWithpx(28)];
        _priceLB.textAlignment = NSTextAlignmentLeft;
        _priceLB.textColor = kRedColor;
        _priceLB.text = @"¥19.00";
    }
    return _priceLB;
}
- (UILabel *)goodsPorpertyLB {
    if (!_goodsPorpertyLB) {
        _goodsPorpertyLB = [[UILabel alloc] init];
        _goodsPorpertyLB.font = WeiMiSystemFontWithpx(22);
        _goodsPorpertyLB.textAlignment = NSTextAlignmentLeft;
//        _goodsPorpertyLB.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _goodsPorpertyLB.numberOfLines = 2;
        _goodsPorpertyLB.text = @"已选：";
    }
    return _goodsPorpertyLB;
}

#pragma mark - Util


#pragma mark - Layout
- (void)updateConstraints {
    [super updateConstraints];
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(90);//_cellImageView.mas_height
    }];
    [_priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_cellImageView).offset(10);
    }];
    [_goodsPorpertyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_priceLB.mas_left);
        make.right.mas_equalTo(_priceLB);
        make.bottom.mas_equalTo(_cellImageView.mas_bottom).offset(-10);
    }];

}


@end
