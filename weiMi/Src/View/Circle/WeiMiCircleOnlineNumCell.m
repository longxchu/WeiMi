//
//  WeiMiCircleOnlineNumCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleOnlineNumCell.h"

#import <UIImageView+WebCache.h>

@interface WeiMiCircleOnlineNumCell()
{
    NSArray *_headerArr;
    NSMutableArray *_imageViewArr;
}

@property (nonatomic, strong) UIImageView *cellImageViewFAC;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation WeiMiCircleOnlineNumCell

- (instancetype)initWithHeaders:(NSArray *)arr reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _headerArr = arr;
        _imageViewArr = [NSMutableArray new];
        NSAssert(arr.count <= 8, @"out of index");
        [_headerArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *url = (NSString *)obj;
                UIImageView *imageView = self.cellImageViewFAC;
                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"weimiQrCode"]];
                [self addSubview:imageView];
                
                [_imageViewArr addObject:imageView];
            }
            
        }];
        [self.contentView addSubview:self.titleLabel];
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    return self;
}

#pragma mark - Getter
- (UIImageView *)cellImageViewFAC
{
   
    UIImageView * cellImageView = [[UIImageView alloc] init];
    cellImageView.image = [UIImage imageNamed:@"followus_bg480x800"];
//    cellImageView.size = CGSizeMake(22, 22);
    cellImageView.layer.masksToBounds = YES;
    cellImageView.layer.cornerRadius = 11.0f;
    return cellImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"227人在线";
    }
    return _titleLabel;
}


#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_imageViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)obj;
            imageView.layer.cornerRadius = imageView.width/2;
        }
    }];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self);
        make.width.mas_lessThanOrEqualTo(120);
    }];
    
    [_imageViewArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:22 leadSpacing:10 tailSpacing:(SCREEN_WIDTH - 30*(_imageViewArr.count))];
    
    [_imageViewArr mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(22);
    }];
}

@end
