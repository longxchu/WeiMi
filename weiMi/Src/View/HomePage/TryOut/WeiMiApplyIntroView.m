//
//  WeiMiApplyIntroView.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiApplyIntroView.h"

@interface WeiMiApplyIntroView()

@property (nonatomic, strong) UILabel *label;

@end

@implementation WeiMiApplyIntroView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = HEX_RGB(0xF9F9F9);
        [self addSubview:self.label];
        
//        _label.frame = CGRectMake(0, 0, SCREEN_WIDTH, 144);
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (UILabel *)label
{
    if (!_label) {
        
        _label = [[UILabel alloc] init];
        _label.font = WeiMiSystemFontWithpx(20);
        _label.textAlignment = NSTextAlignmentLeft;
        _label.textColor = [UIColor darkGrayColor];
        _label.numberOfLines = 0;
        _label.text = @"● 需要在唯蜜生活商城有成功下单购买记录;\n● 申请成功名单在活动结束后2-3天内公布，试用中心将电话通知您;\n● 收到货后10天内必须提交真实的试用报告，无需返还试用品;\n● 优质的试用报告可以提升您下次申请成功几率，劣质试用报告将使您被限制申请";
//        [_label sizeToFit];
    }
    return _label;
}

#pragma mark - layout
- (void)updateConstraints
{
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-10);
    }];
    [super updateConstraints];

}
@end
