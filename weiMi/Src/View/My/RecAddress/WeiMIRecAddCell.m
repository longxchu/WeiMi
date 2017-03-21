//
//  WeiMIRecAddCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMIRecAddCell.h"
#import "UIButton+CenterImageAndTitle.h"

@interface WeiMIRecAddCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *telLabel;

@property (nonatomic, strong) UIImageView *lineImageView;

@property (nonatomic, strong) UIButton *setDefaultBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation WeiMIRecAddCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.telLabel];
        [self addSubview:self.addressLabel];
        [self addSubview:self.lineImageView];
        [self addSubview:self.setDefaultBtn];
        [self addSubview:self.editBtn];
        [self addSubview:self.deleteBtn];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiRecAddDTO *)dto
{
    _nameLabel.text = dto.name;
    _telLabel.text = dto.tel;
    _addressLabel.text = dto.street;
    _setDefaultBtn.selected = dto.isDefault;
    
    self.dto = dto;
}

#pragma mark  - Actions
- (void)onButton:(UIButton *)button
{
    if (button == _setDefaultBtn) {
        button.selected  = !button.selected;
        OnSetDefaultHandler block = self.onSetDefaultHandler;
        if (block) {
            block(button);
        }
    }else if (button == _editBtn)
    {
        OnEditHandler block = self.onEditHandler;
        if (block) {
            block();
        }
    }else if (button == _deleteBtn)
    {
        OnDeleteHandler block = self.onDeleteHandler;
        if (block) {
            block();
        }
    }
    
}

#pragma mark - Getter
- (UIButton *)setDefaultBtn
{
    if (!_setDefaultBtn) {
        
        _setDefaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _setDefaultBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_setDefaultBtn setTitle:@"设为默认地址" forState:UIControlStateNormal];
        [_setDefaultBtn setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        [_setDefaultBtn setImage:[UIImage imageNamed:@"icon_circle"] forState:UIControlStateNormal];
        [_setDefaultBtn setImage:[UIImage imageNamed:@"icon_ball_pre"] forState:UIControlStateSelected];
        [_setDefaultBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setDefaultBtn;
}

- (UIButton *)editBtn
{
    if (!_editBtn) {
        
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.layer.masksToBounds = YES;
        _editBtn.layer.cornerRadius = 3.0f;
        _editBtn.layer.borderWidth = 1.0f;
        _editBtn.layer.borderColor = kGrayColor.CGColor;
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.layer.masksToBounds = YES;
        _deleteBtn.layer.borderWidth = 1.0f;
        _deleteBtn.layer.cornerRadius = 3.0f;
        _deleteBtn.layer.borderColor = kGrayColor.CGColor;
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIImageView *)lineImageView
{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 2)];

    }
    return _lineImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"Arial" size:16];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"madaoCN";
    }
    return _nameLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont fontWithName:@"Arial" size:14];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.text = @"上海,上海市,普陀区,金沙江路";
    }
    return _addressLabel;
}

- (UILabel *)telLabel
{
    if (!_telLabel) {
        _telLabel = [[UILabel alloc] init];
        _telLabel.font = [UIFont fontWithName:@"Arial" size:16];
        _telLabel.textAlignment = NSTextAlignmentRight;
        _telLabel.text = @"13055424951";
    }
    return _telLabel;
}

// 返回虚线image的方法
- (UIImage *)drawLineByImageView:(UIImageView *)imageView{
    
    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度 1是高度
    CGFloat lengths[] = {2,2};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithWhite:0.408 alpha:1.000].CGColor);
    CGContextSetLineDash(line, 0, lengths, 1); //画虚线
    CGContextMoveToPoint(line, 0.0, 2.0); //开始画线
    CGContextAddLineToPoint(line, SCREEN_WIDTH, 2.0);
    
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

#pragma mark - layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_setDefaultBtn horizontalCenterImageAndTitle:10];
}

- (void)updateConstraints
{
    [_telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.mas_equalTo(10);
        make.right.mas_equalTo(_telLabel.mas_left);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_nameLabel);
        make.right.mas_equalTo(_telLabel);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
    }];
    
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.top.mas_equalTo(self.height*0.6);
    }];
    
    // 调用方法 返回的iamge就是虚线
    _lineImageView.image = [self drawLineByImageView:_lineImageView];
    
    [_setDefaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_nameLabel).offset(-5);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_lineImageView.mas_bottom);
        make.width.mas_equalTo(135);
    }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_setDefaultBtn);
        make.size.mas_equalTo(CGSizeMake(70, 30));
        make.right.mas_equalTo(_deleteBtn.mas_left).offset(-10);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_setDefaultBtn);
        make.size.mas_equalTo(CGSizeMake(70, 30));
        make.right.mas_equalTo(_telLabel);
    }];
    [super updateConstraints];
}
@end
