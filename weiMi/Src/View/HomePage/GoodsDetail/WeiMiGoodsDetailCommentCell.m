//
//  WeiMiGoodsDetailCommentCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/12.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiGoodsDetailCommentCell.h"
#import "WeiMiCommentStarView.h"



@interface WeiMiGoodsDetailCommentCell()
{
    WeiMiProductCommentDTO *_dto;
}

@property (nonatomic, strong) UILabel *commentLB;
@property (nonatomic, strong) UILabel *creditLB;

@property (nonatomic, strong) WeiMiCommentStarView *starView;

@end

@implementation WeiMiGoodsDetailCommentCell


+ (CGFloat)getHeightWithContent:(WeiMiProductCommentDTO *)dto
{
    static WeiMiGoodsDetailCommentCell *testCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        testCell = [[WeiMiGoodsDetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"testCell"];
    });
    
//    [testCell setViewWithDTO:dto];
//    
//    [testCell setNeedsLayout];
//    [testCell layoutIfNeeded];
    
    CGFloat height = 40;
    height += [dto.msgContext returnSize:testCell.commentLB.font MaxWidth:SCREEN_WIDTH - 20].height;
    
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.commentLB];
        [self addSubview:self.creditLB];
        
//        [self addSubview:self.starView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiProductCommentDTO *)dto
{
    _dto = dto;
    _commentLB.text = dto.msgContext;
    _creditLB.text = [NSString stringWithFormat:@"%@ %@", dto.strName, dto.createTime];
    
    if (!_starView) {
        [self addSubview:self.starView];
        [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
            
//            make.left.top.mas_equalTo(10);
            make.centerY.mas_equalTo(_creditLB);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(24);
        }];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    
}

#pragma mark - Getter
- (WeiMiCommentStarView *)starView
{
    if (!_starView) {
        _starView = [[WeiMiCommentStarView alloc] initWithFrame:CGRectZero startNum:_dto.msxf starNormalImg:@"icon_purple_small_fivestar" selected:@"icon_purple_small_fivestar"];
        [_starView setLightNum:_dto.msxf ];
        _starView.userInteractionEnabled = NO;
    }
    return _starView;
}

- (UILabel *)commentLB
{
    if (!_commentLB) {
        
        _commentLB = [[UILabel alloc] init];
        _commentLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
        _commentLB.textAlignment = NSTextAlignmentLeft;
        _commentLB.numberOfLines = 0;
        _commentLB.text = @"用户评价(54人)";
        _commentLB.textColor = kGrayColor;
    }
    return _commentLB;
}

- (UILabel *)creditLB
{
    if (!_creditLB) {
        
        _creditLB = [[UILabel alloc] init];
        _creditLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        [_creditLB sizeToFit];
        _creditLB.textAlignment = NSTextAlignmentLeft;
        _creditLB.text = @"啊**呵呵 2015-04-09";
        _creditLB.textColor = kGrayColor;
    }
    return _creditLB;
}

#pragma mark - Layout
- (void)updateConstraints
{
    [_commentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_creditLB.mas_bottom).offset(5);
    }];
    
    [_creditLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
//        make.centerY.mas_equalTo(_starView);
    }];
    

//    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.top.mas_equalTo(10);
//        make.width.mas_equalTo(80);
//        make.height.mas_equalTo(24);
//    }];
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
