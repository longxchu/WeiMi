//
//  WeiMiLogisticsStatusCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/15.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiLogisticsStatusCell.h"
#import <QuartzCore/QuartzCore.h>
#import <Masonry.h>

#define TITLE_COLOR [[UIColor orangeColor] colorWithAlphaComponent:0.99]
#define RADIO_BG_COLOR   (0xD8D8D8)
#define RADIO_CIRCLE_COLRO (0x7CC982)
#define RADIO_CIRCLE_LLIGHTCOLRO (0xD2EED7)
static const CGFloat kBorderWidth = 2.0f;
static const CGFloat kCircleRadius = 4.0f;
static const CGFloat kProgressViewWidth = 20.0f;
static const CGFloat kLineWidth = 2.0f;

@interface WeiMiLogisticsStatusCell()
{
    NSMutableArray *_layers;
    /// 是否已经添加过了layer 防止重复添加layer
    BOOL _addedLayer;
    /// 状态
    YinzhiDirectoryCellStatus _status;
}
/// 详情Label
@property (nonatomic, strong) UILabel *detailLabel;
///
@property (nonatomic, strong) UILabel *dateLabel;

/// progressView容器视图
@property(nonatomic, strong) UIView *progressViewContainer;
/// 圆形灰色图层
@property (nonatomic, strong) CAShapeLayer *circleLayer;
/// 圆形绿色图层
@property (nonatomic, strong) CAShapeLayer *circleGreenLayer;
@property (nonatomic, strong) CAShapeLayer *circleLightGreenLayer;
/// 上接线图层
@property (nonatomic, strong) CAShapeLayer *upperLineLayer;
/// 下接线图层
@property (nonatomic, strong) CAShapeLayer *bottomLineLayer;
/// 已读圆形图层
@property (nonatomic, strong) CAShapeLayer *soildCircleLayer;

@end

@implementation WeiMiLogisticsStatusCell

#pragma mark - LifeCycle
- (instancetype)initWithStatus:(YinzhiDirectoryCellStatus)status reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _status = status;
        _addedLayer = NO;
        [self initSubViews];
    }
    return self;
}

+ (CGFloat)getHeightWithTitle:(NSString *)title date:(NSString *)date
{
    static WeiMiLogisticsStatusCell *testCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        testCell = [[WeiMiLogisticsStatusCell alloc] initWithStatus:YinzhiDirectoryCellStatus_single reuseIdentifier:@"testCell"];
    });
    
    [testCell setViewWithTitle:title date:date];
    
    [testCell setNeedsLayout];
    [testCell layoutIfNeeded];
    
    return testCell.dateLabel.bottom + 10;
}

- (void)setViewWithTitle:(NSString *)title date:(NSString *)date
{
    _detailLabel.text = title;
    _dateLabel.text = date;
}

- (void)initSubViews
{
    [self addSubview:self.detailLabel];
    [self addSubview:self.dateLabel];
    [self addSubview:self.progressViewContainer];
    
    //    [self.progressViewContainer.layer addSublayer:self.upperLineLayer];
    //    [self.progressViewContainer.layer addSublayer:self.circleLayer];
    //    [self.progressViewContainer.layer addSublayer:self.bottomLineLayer];
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - Getter

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor darkGrayColor];
        _detailLabel.numberOfLines = 2;
        _detailLabel.text = @"派送中：货物已经由上海市发往北京，北京已经揽收";
        _detailLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
    }
    
    return _detailLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor darkGrayColor];
        _dateLabel.text = @"2016年9月20日";
        _dateLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(18)];
    }
    
    return _dateLabel;
}

- (CAShapeLayer *)circleLayer
{
    if (!_circleLayer) {
        
        CGFloat yCenter = CGRectGetHeight(self.frame)/2;
        UIBezierPath *circle = [UIBezierPath bezierPath];
        [self configureBezierCircle:circle withCenterY:yCenter radius:kCircleRadius];
        _circleLayer = [self getLayerWithCircle:circle andStrokeColor:HEX_RGB(RADIO_BG_COLOR) fillColor:nil];
    }
    return _circleLayer;
}

- (CAShapeLayer *)soildCircleLayer
{
    if (!_soildCircleLayer) {
        
        CGFloat yCenter = CGRectGetHeight(self.frame)/2;
        UIBezierPath *circle = [UIBezierPath bezierPath];
        [self configureBezierCircle:circle withCenterY:yCenter radius:kCircleRadius];
        _soildCircleLayer = [self getLayerWithCircle:circle andStrokeColor:HEX_RGB(RADIO_BG_COLOR) fillColor:HEX_RGB(RADIO_BG_COLOR)];
    }
    return _soildCircleLayer;
}

- (CAShapeLayer *)circleGreenLayer
{
    if (!_circleGreenLayer) {
        CGFloat yCenter = CGRectGetHeight(self.frame)/2;
        UIBezierPath *circle = [UIBezierPath bezierPath];
        [self configureBezierCircle:circle withCenterY:yCenter radius:kCircleRadius*1.5];
        _circleGreenLayer = [self getLayerWithCircle:circle andStrokeColor:HEX_RGB(RADIO_CIRCLE_COLRO) fillColor:HEX_RGB(RADIO_CIRCLE_COLRO)];
    }
    return _circleGreenLayer;
}

- (CAShapeLayer *)circleLightGreenLayer
{
    if (!_circleLightGreenLayer) {
        CGFloat yCenter = CGRectGetHeight(self.frame)/2;
        UIBezierPath *circle = [UIBezierPath bezierPath];
        [self configureBezierCircle:circle withCenterY:yCenter radius:kCircleRadius*1.5+3];
        _circleLightGreenLayer = [self getLayerWithCircle:circle andStrokeColor:HEX_RGB(RADIO_CIRCLE_LLIGHTCOLRO) fillColor:HEX_RGB(RADIO_CIRCLE_LLIGHTCOLRO)];
    }
    return _circleLightGreenLayer;
}

- (UIView *)progressViewContainer
{
    if (!_progressViewContainer) {
        
        _progressViewContainer = [[UIView alloc] init];
    }
    return _progressViewContainer;
}

- (CAShapeLayer *)upperLineLayer
{
    if (!_upperLineLayer) {
        CGPoint startPoint = CGPointMake(kProgressViewWidth / 2, 0);
        CGPoint endPoint = CGPointMake(kProgressViewWidth / 2, CGRectGetHeight(self.frame)/2 - kCircleRadius);
        UIBezierPath *line = [self getLineWithStartPoint:startPoint endPoint:endPoint];
        _upperLineLayer = [self getLayerWithLine:line andStrokeColor:HEX_RGB(RADIO_BG_COLOR)];
    }
    return _upperLineLayer;
}

- (CAShapeLayer *)bottomLineLayer
{
    if (!_bottomLineLayer) {
        
        CGPoint startPoint = CGPointMake(kProgressViewWidth / 2, CGRectGetHeight(self.frame)/2 + kCircleRadius);
        CGPoint endPoint = CGPointMake(kProgressViewWidth / 2, CGRectGetHeight(self.frame));
        UIBezierPath *line = [self getLineWithStartPoint:startPoint endPoint:endPoint];
        _bottomLineLayer = [self getLayerWithLine:line andStrokeColor:HEX_RGB(RADIO_BG_COLOR)];
    }
    return _bottomLineLayer;
}

#pragma mark - CommonMethods
- (void)configureBezierCircle:(UIBezierPath *)circle withCenterY:(CGFloat)centerY radius:(CGFloat)radius{
    [circle addArcWithCenter:CGPointMake(self.progressViewContainer.center.x  +
                                         kProgressViewWidth / 2, centerY)
                      radius:radius
                  startAngle:M_PI_2
                    endAngle:-M_PI_2
                   clockwise:YES];
    [circle addArcWithCenter:CGPointMake(self.progressViewContainer.center.x +
                                         kProgressViewWidth / 2, centerY)
                      radius:radius
                  startAngle:-M_PI_2
                    endAngle:M_PI_2
                   clockwise:YES];
}

- (UIBezierPath *)getLineWithStartPoint:(CGPoint)start endPoint:(CGPoint)end {
    UIBezierPath *line = [UIBezierPath bezierPath];
    [line moveToPoint:start];
    [line addLineToPoint:end];
    
    return line;
}

- (CAShapeLayer *)getLayerWithCircle:(UIBezierPath *)circle andStrokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor{
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = CGRectMake(0, 0, kProgressViewWidth, CGRectGetHeight(self.frame));
    circleLayer.path = circle.CGPath;
    
    circleLayer.strokeColor = strokeColor.CGColor;
    circleLayer.fillColor = nil;
    if (fillColor) {
        circleLayer.fillColor = fillColor.CGColor;
    }
    
    circleLayer.lineWidth = kLineWidth;
    circleLayer.lineJoin = kCALineJoinBevel;
    
    return circleLayer;
}

- (CAShapeLayer *)getLayerWithLine:(UIBezierPath *)line andStrokeColor:(UIColor *)strokeColor {
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = line.CGPath;
    lineLayer.strokeColor = strokeColor.CGColor;
    lineLayer.fillColor = nil;
    lineLayer.lineWidth = kLineWidth;
    
    return lineLayer;
}

#pragma mark - Constraint
- (void)layoutSubviews
{
    _detailLabel.preferredMaxLayoutWidth = self.width - 38;
    _dateLabel.preferredMaxLayoutWidth = self.width - 38;
    // 添加layer
    if (!_addedLayer) {
        


//        [self.progressViewContainer.layer addSublayer:self.circleLayer];
        
        switch (_status) {
            case YinzhiDirectoryCellStatus_single:
            {
                [self.progressViewContainer.layer addSublayer:self.bottomLineLayer];
                [self.progressViewContainer.layer addSublayer:self.circleLightGreenLayer];
                [self.progressViewContainer.layer addSublayer:self.circleGreenLayer];
                
                _dateLabel.textColor = _detailLabel.textColor = HEX_RGB(RADIO_CIRCLE_COLRO);
            }
            case YinzhiDirectoryCellStatus_upper:
            {
                [self.progressViewContainer.layer addSublayer:self.bottomLineLayer];
                [self.progressViewContainer.layer addSublayer:self.circleLightGreenLayer];
                [self.progressViewContainer.layer addSublayer:self.circleGreenLayer];
                
                _dateLabel.textColor = _detailLabel.textColor = HEX_RGB(RADIO_CIRCLE_COLRO);

                break;
            }
            case YinzhiDirectoryCellStatus_mid:
            {
                [self.progressViewContainer.layer addSublayer:self.soildCircleLayer];
                [self.progressViewContainer.layer addSublayer:self.upperLineLayer];
                [self.progressViewContainer.layer addSublayer:self.bottomLineLayer];
                break;
            }
            case YinzhiDirectoryCellStatus_bottom:
            {
                [self.progressViewContainer.layer addSublayer:self.soildCircleLayer];
                [self.progressViewContainer.layer addSublayer:self.upperLineLayer];
                break;
            }
            default:
                break;
        }
        
        _addedLayer = YES;
    }
    
    [super layoutSubviews];
}

- (void)updateConstraints
{
    
    [_progressViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kProgressViewWidth);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_progressViewContainer.mas_right).offset(5);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_detailLabel);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_detailLabel.mas_bottom).offset(5);
    }];
    
    [super updateConstraints];
}

@end
