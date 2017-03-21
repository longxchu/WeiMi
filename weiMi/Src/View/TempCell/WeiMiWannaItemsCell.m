//
//  WeiMiWannaItemsCell.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/21.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiWannaItemsCell.h"
#import "WeiMiWannaItem.h"

//---------DTO
#import "WeiMiHPProductListDTO.h"//商品
#import "WeiMiMFInvitationListDTO.h"//帖子
#import "WeiMiHotCommandDTO.h"//热帖
#import "WeiMiHomePageBannerDTO.h"

@interface WeiMiWannaItemsCell()
{
    WeiMiBaseDTO *_lDTO;
    WeiMiBaseDTO *_rDTO;
}

@property (nonatomic, strong) WeiMiWannaItem *leftItem;
@property (nonatomic, strong) WeiMiWannaItem *rightItem;

@end

@implementation WeiMiWannaItemsCell

+ (CGFloat)getHeight
{
    
    return SCREEN_WIDTH/2;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.leftItem];
        [self.contentView addSubview:self.rightItem];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithLeftDTO:(WeiMiBaseDTO *)ldto rightDTO:(WeiMiBaseDTO *)rdto
{
    _lDTO = ldto;
    _rDTO = rdto;
    if ([ldto isKindOfClass:[WeiMiHPProductListDTO class]]) {
        
        [_leftItem setItemWithTitle:((WeiMiHPProductListDTO *)_lDTO).productName img:WEIMI_IMAGEREMOTEURL(((WeiMiHPProductListDTO *)_lDTO).faceImgPath)];
    }else if ([ldto isKindOfClass:[WeiMiHotCommandDTO class]])
    {
        [_leftItem setItemWithTitle:((WeiMiHotCommandDTO *)_lDTO).infoTitle img:WEIMI_IMAGEREMOTEURL(((WeiMiHotCommandDTO *)_lDTO).imgPath)];
    }else if([ldto isKindOfClass:[WeiMiHomePageBannerDTO class]]){
        [_leftItem setItemWithTitle:nil img:((WeiMiHomePageBannerDTO *)_lDTO).bannerImgPath];
    }
    if ([rdto isKindOfClass:[WeiMiHPProductListDTO class]]) {
        
        [_rightItem setItemWithTitle:((WeiMiHPProductListDTO *)_rDTO).productName img:WEIMI_IMAGEREMOTEURL(((WeiMiHPProductListDTO *)_rDTO).faceImgPath)];
    }else if ([rdto isKindOfClass:[WeiMiHotCommandDTO class]])
    {
         [_rightItem setItemWithTitle:((WeiMiHotCommandDTO *)_rDTO).infoTitle img:WEIMI_IMAGEREMOTEURL(((WeiMiHotCommandDTO *)_rDTO).imgPath)];
    }else if([ldto isKindOfClass:[WeiMiHomePageBannerDTO class]]){
        [_rightItem setItemWithTitle:nil img:((WeiMiHomePageBannerDTO *)_rDTO).bannerImgPath];
    }
}

#pragma mark - Getter
- (WeiMiWannaItem *)leftItem
{
    if (!_leftItem) {
        _leftItem = [[WeiMiWannaItem alloc] init];
        [_leftItem addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftItem;
}

- (WeiMiWannaItem *)rightItem
{
    if (!_rightItem) {
        _rightItem = [[WeiMiWannaItem alloc] init];
        [_rightItem addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightItem;
}

#pragma mark - Actions
- (void)onButton:(id)sender
{
    OnWannCellItemHandler handler = self.onWannCellItemHandler;

    if (sender == self.leftItem)
    {
        if (handler) {
            handler(_lDTO);
        }
    }else if (sender == self.rightItem)
    {

        if (handler) {
            handler(_rDTO);
        }
    }
}

- (void)updateConstraints
{
    
    [@[_leftItem, _rightItem] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [@[_leftItem, _rightItem] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(_leftItem.mas_width).priorityHigh();
    }];
    [super updateConstraints];
}


@end
