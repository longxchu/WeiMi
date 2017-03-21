//
//  WeiMiMsgReplyMeCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMsgReplyMeCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+CenterImageAndTitle.h"


@interface WeiMiMsgReplyMeCell()


@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *commentLB;
@property (nonatomic, strong) UILabel *replyLB;
@property (nonatomic, strong) UIView *replyBgView;

@property (nonatomic, strong) UILabel *tagLB;

@property (nonatomic, strong) UIButton *commentBTN;
@end

@implementation WeiMiMsgReplyMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cellImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.commentLB];
        
        [self.contentView addSubview:self.replyBgView];
        [self.contentView addSubview:self.replyLB];

         [self.contentView addSubview:self.tagLB];
         [self.contentView addSubview:self.commentBTN];
        [self setNeedsUpdateConstraints];
    }
    return self;
}


+ (CGFloat)getHeightWithDTO:(WeiMiReplyMeMsgDTO *)dto
{
    static WeiMiMsgReplyMeCell *testCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        testCell = [[WeiMiMsgReplyMeCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"testCell"];
    });
    
    [testCell setViewWithDTO:dto];
    
    [testCell setNeedsLayout];
    [testCell layoutIfNeeded];
    
    CGFloat height = GetAdapterHeight(90);
    height += [dto.commentStr returnSize:testCell.commentLB.font MaxWidth:testCell.commentLB.width].height;
    height += [dto.replyStr returnSize:testCell.replyLB.font MaxWidth:testCell.replyLB.width].height;

    return height + 60;
}

- (void)setViewWithDTO:(WeiMiReplyMeMsgDTO *)dto
{
    _titleLabel.attributedText = [self attrStringWithUserName:dto.userName date:dto.time];
    _commentLB.text = dto.commentStr;
    _replyLB.text = [NSString stringWithFormat: @"回复我的帖子:%@", dto.replyStr];
    _tagLB.text = dto.tagStr;

}


#pragma mark - Getter
- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.layer.masksToBounds = YES;
        [_cellImageView sd_setImageWithURL:[NSURL URLWithString:TEST_IMAGE_URL] placeholderImage:[UIImage imageNamed:@"weimiQrCode"]];
    }
    return _cellImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.numberOfLines = 2;
        _titleLabel.attributedText = [self attrStringWithUserName:@"小美女" date:@"2012年5月"];
    }
    return _titleLabel;
}

- (UILabel *)commentLB
{
    if (!_commentLB) {
        
        _commentLB = [[UILabel alloc] init];
        _commentLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        _commentLB.textAlignment = NSTextAlignmentLeft;
        _commentLB.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _commentLB.numberOfLines = 0;
        _commentLB.text = @"写的不错啊！";
    }
    return _commentLB;
}

- (UILabel *)replyLB
{
    if (!_replyLB) {
        
        _replyLB = [[UILabel alloc] init];
        _replyLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _replyLB.textAlignment = NSTextAlignmentLeft;
        _replyLB.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _replyLB.numberOfLines = 0;
        _replyLB.text = @"回复我的帖子:宫保鸡丁的做法！";
    }
    return _replyLB;
}

- (UIView *)replyBgView
{
    if (!_replyBgView) {
        
        _replyBgView = [[UIView alloc] init];
        _replyBgView.backgroundColor = HEX_RGB(0xF8F8F8);
    }
    return _replyBgView;
}

- (UILabel *)tagLB
{
    if (!_tagLB) {
        
        _tagLB = [[UILabel alloc] init];
        _tagLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _tagLB.textAlignment = NSTextAlignmentLeft;
        _tagLB.textColor = HEX_RGB(0x0BA5C1);
        _tagLB.text = @"吃货的厨房";
    }
    return _tagLB;
}

- (UIButton *)commentBTN
{
    if (!_commentBTN) {
        _commentBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBTN setTitle:@"回复" forState:UIControlStateNormal];
        [_commentBTN setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        _commentBTN.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(18)];
        [_commentBTN setImage:[UIImage imageNamed:@"reply_me_icon_small_xiaoxi"] forState:UIControlStateNormal];
        [_commentBTN setImage:[UIImage imageNamed:@"reply_me_icon_small_xiaoxi"] forState:UIControlStateHighlighted];
        [_commentBTN setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    return _commentBTN;
}

#pragma mark - Utils
- (NSMutableAttributedString *)attrStringWithUserName:(NSString *)userName date:(NSString *)date
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5.0f;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:userName attributes:@{
                                                                                                                   NSFontAttributeName:WeiMiSystemFontWithpx(22)}];
    NSAttributedString *sufStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", date] attributes:@{
                                                                                                                                   NSFontAttributeName:WeiMiSystemFontWithpx(18)}];
    
    [attString appendAttributedString:sufStr];
    [attString addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, userName.length + date.length)];
    return attString;
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    _cellImageView.layer.cornerRadius = _cellImageView.width/2;

    [_commentBTN horizontalCenterImageAndTitle:12];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    _commentLB.preferredMaxLayoutWidth = SCREEN_WIDTH - 20;
    _replyLB.preferredMaxLayoutWidth = SCREEN_WIDTH - 20;
    
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(10);
//        make.height.mas_equalTo(self).multipliedBy(0.4);
        make.height.mas_equalTo(GetAdapterHeight(60));
        make.width.mas_equalTo(_cellImageView.mas_height);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(_cellImageView);
        make.height.mas_equalTo(_cellImageView);
    }];
    
    [_commentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_cellImageView.mas_bottom).offset(10);
    }];
    
    [_replyBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_commentLB.mas_bottom).offset(5);
        make.bottom.mas_equalTo(_replyLB.mas_bottom).offset(10);
    }];
    
    [_replyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_commentLB);
        make.top.mas_equalTo(_replyBgView).offset(10);
//        make.bottom.mas_lessThanOrEqualTo(_tagLB.mas_bottom).offset(15);
    }];

    [_tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_replyBgView.mas_bottom).offset(5).priorityHigh();
        make.left.mas_equalTo(_cellImageView);
        make.bottom.mas_lessThanOrEqualTo(-5);
        make.right.mas_equalTo(_commentBTN.mas_left);
    }];
    
    [_commentBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-20);
        make.center.mas_equalTo(_tagLB);
    }];
    
//    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
//        make.right.mas_equalTo(-10);
//        make.bottom.mas_equalTo(_cellImageView);
//    }];
}


@end
