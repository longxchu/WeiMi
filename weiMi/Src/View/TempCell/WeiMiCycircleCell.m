//
//  WeiMiCycircleCell.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/21.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCycircleCell.h"
#import "CycleScrollView.h"
#import <UIImageView+WebCache.h>
// ------ request
#import "WeiMiBannerRequest.h"
#import "WeiMiBannerResponse.h"

@interface WeiMiCycircleCell()

@property (nonatomic,strong) CycleScrollView *cycleScrollView;

@end

@implementation WeiMiCycircleCell

+ (CGFloat)getHeight
{
    return 0.624*SCREEN_WIDTH;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

        [self.contentView addSubview:self.cycleScrollView];

//        [self loadAdvert:nil];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (CycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView=[[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GetAdapterHeight(467/2)) animationDuration:4];
        _cycleScrollView.backgroundColor=[UIColor grayColor];
        _cycleScrollView.pageControl.currentPageIndicatorTintColor = HEX_RGB(BASE_COLOR_HEX);
        _cycleScrollView.pageControl.pageIndicatorTintColor = kGrayColor;
    }
    return _cycleScrollView;
}

#pragma mark - Utils
/**
 *  图片轮播
 */
-(void)loadAdvert:(NSArray *)bannerArr
{
    WS(weakSelf);
    
    self.cycleScrollView.fetchContentViewAtIndex=^UIView *(NSInteger pageIndex){
        
        NSString *imageUrl = ((WeiMiHomePageBannerDTO *)safeObjectAtIndex(bannerArr, pageIndex)).bannerImgPath;
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, weakSelf.cycleScrollView.width, weakSelf.cycleScrollView.height)];
        if (!imageUrl) {
            imageview.image = WEIMI_PLACEHOLDER_COMMON;
        }else
        {
            [imageview sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(imageUrl)] placeholderImage:WEIMI_PLACEHOLDER_COMMON];
        }
        
        return imageview;
    };
    
    self.cycleScrollView.totalPagesCount=^NSInteger(void){
        
        if (!bannerArr.count) {
            return 1;
        }
        return bannerArr.count;
    };
    
    self.cycleScrollView.TapActionBlock=^(NSInteger pageIndex){
        
        SS(strongSelf);
        OnWannCellItem block = strongSelf.onWannCellItem;
        if (block) {
            NSString *bannerId = ((WeiMiHomePageBannerDTO *)safeObjectAtIndex(bannerArr, pageIndex)).bannerId;
            block(bannerId ? bannerId : @"");
        }
    };
}

- (void)updateConstraints
{
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self);
    }];

    [super updateConstraints];
}



@end
