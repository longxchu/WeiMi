//
//  WeiMiOrderUploadCerView.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiOrderUploadCerView.h"
#import <QuartzCore/QuartzCore.h>

@interface WeiMiOrderUploadCerView()

@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) CAShapeLayer *shapLayer;

@end

@implementation WeiMiOrderUploadCerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kClearColor;
        
        [self addSubview:self.rightLabel];
        [self addSubview:self.leftButton];
        [self.layer addSublayer:self.shapLayer];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton sizeToFit];
//        _leftButton.titleLabel.font = WeiMiSystemFontWithpx(19);
//        [_leftButton setTitle:@"积分说明" forState:UIControlStateNormal];
//        [_leftButton setTitleColor:HEX_RGB(0x0AA0E6) forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"icon_camera_gray"] forState:UIControlStateNormal];
//        [_leftButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (CAShapeLayer *)shapLayer
{
    if(!_shapLayer)
    {
        _shapLayer = [CAShapeLayer layer];
        
        _shapLayer.strokeColor = kGrayColor.CGColor;
        _shapLayer.fillColor = nil;
        _shapLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:3.0f].CGPath;
        _shapLayer.frame = self.bounds;
        _shapLayer.lineWidth = 1.0f;
        _shapLayer.lineCap = @"square";
        _shapLayer.lineDashPattern = @[@4, @4];
    }
    return _shapLayer;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.font = WeiMiSystemFontWithpx(22);
        _rightLabel.textColor = kGrayColor;
        _rightLabel.text = @"上传凭证，最多三张";
        [_rightLabel sizeToFit];
        //        _creditLabel.textColor = kGrayColor;
    }
    return _rightLabel;
}

#pragma mark - Util
- (NSMutableAttributedString *)attrStringWithSuff:(NSString *)suff
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:suff attributes:@{
                                                                                                               NSFontAttributeName:WeiMiSystemFontWithpx(62), NSForegroundColorAttributeName:HEX_RGB(0xF4480B)}];
    NSAttributedString *sufStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"分"] attributes:@{
                                                                                                                          NSFontAttributeName:WeiMiSystemFontWithpx(28), NSForegroundColorAttributeName:HEX_RGB(0xF4480B)}];
    
    [attString appendAttributedString:sufStr];
    return attString;
}

#pragma mark - Actions

- (void)updateConstraints
{
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-15);
        //        make.height.mas_equalTo(self.height/3*2);
    }];
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(15);
    }];
    [super updateConstraints];
}


@end
