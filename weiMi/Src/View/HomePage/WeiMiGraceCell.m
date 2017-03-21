//
//  WeiMiGraceCell.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiGraceCell.h"
#import "WeiMiTextScrollVIew.h"

#define LINE_COLOR      (0xE9E9E9)
@interface WeiMiGraceCell()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *tagLabel;

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) WeiMiTextScrollVIew *textScrollView;
@property (nonatomic, strong) UIButton *maskBTN;
@end

@implementation WeiMiGraceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cellImageView];
        [self.contentView addSubview:self.tagLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.maskBTN];
        [self.contentView addSubview:self.textScrollView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (WeiMiTextScrollVIew *)textScrollView
{
    if (!_textScrollView) {
        _textScrollView = [[WeiMiTextScrollVIew alloc] initWithFrame:CGRectMake(165, 0, SCREEN_WIDTH-165, 43)];
        _textScrollView.textAlignment = NSTextAlignmentLeft;
        _textScrollView.titleFont = kFontSizeWithpx(21);
        _textScrollView.BGColor = kWhiteColor;
//        [_textScrollView clickTitleLabel:_clickLabelHandler];
        WS(weakSelf);
        _textScrollView.clickLabelBlock = ^(NSInteger idx)
        {
            SS(strongSelf);
            GraceCellClickLabelHandler handler = strongSelf.clickLabelHandler;
            if (handler) {
                handler(idx);
            }
        };
    }
    return _textScrollView;
}
- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.image =[UIImage imageNamed: @"weimitehui"];
        _cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _cellImageView;
}
- (void)setTitleArr:(NSArray *)titleArr {
    self.textScrollView.titleArray = titleArr;
}
- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.text = @"福利";
//        [_tagLabel sizeToFit];
        _tagLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        _tagLabel.textColor = HEX_RGB(0xF81818);
        _tagLabel.layer.masksToBounds = YES;
        _tagLabel.layer.borderColor = HEX_RGB(0xF81818).CGColor;
        _tagLabel.layer.cornerRadius = 3.0f;
        _tagLabel.layer.borderWidth = 1.0f;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}

//- (UILabel *)detailLabel
//{
//    if (!_detailLabel) {
//        
//        _detailLabel = [[UILabel alloc] init];
//        _detailLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(15)];
//        _detailLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
//        _detailLabel.textAlignment = NSTextAlignmentLeft;
//        _detailLabel.text = @"不要999,59带个女友回家~";
//    }
//    return _detailLabel;
//}
- (UIButton *)maskBTN
{
    if (!_maskBTN) {
        _maskBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_maskBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _maskBTN;
}

#pragma mark - Actions
- (void)onButton:(id)sender
{
    if (sender == _maskBTN) {
        GraceCellClickImgHandler handler = self.clickImgHandler;
        if (handler) {
            handler();
        }

    }
}
#pragma mark - Layout
- (void)updateConstraints
{
    [_maskBTN mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.mas_equalTo(self.cellImageView);
    }];
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(100);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(12);
        make.centerY.mas_equalTo(self);
//        make.width.mas_equalTo(33);
        CGSize size = [_tagLabel.text returnSize:_tagLabel.font];
        make.size.mas_equalTo(CGSizeMake(size.width + 5, size.height + 5));
    }];
    
//    [_textScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_tagLabel.mas_right).offset(5);
//        make.right.mas_equalTo(-5);
//        make.centerY.mas_equalTo(self);
//    }];
    
    [super updateConstraints];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat LineHeight = 1.0f;
    CGFloat LineOffSet = 10.0f;
    CGPoint start = CGPointMake(self.cellImageView.right + 5, LineOffSet);
    CGPoint end = CGPointMake(self.cellImageView.right + 5, self.height - LineOffSet);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
       CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddLineToPoint(context, end.x, end.y);
    //设置颜色和线条宽度
    CGContextSetLineWidth(context, LineHeight);
    CGContextSetStrokeColorWithColor(context, HEX_RGB(LINE_COLOR).CGColor);
    //渲染
    CGContextStrokePath(context);
}

@end
