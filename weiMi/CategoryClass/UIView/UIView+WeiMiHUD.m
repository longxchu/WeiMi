//
//  UIView+WeiMiHUD.m
//  app
//
//  Created by Ning Gang on 16/6/1.
//  Copyright © 2016年 WeiMi. All rights reserved.
//

#import "UIView+WeiMiHUD.h"
#define indicatorHUDTag                     0x98751246
#define textHUDTag                          0x98751247

@implementation UIView (WeiMiHUD)

- (void)showIndicatorHUD:(NSString *)indiTitle
{
    MBProgressHUD *HUD = [self getIndicatorHUD];
    
    HUD.labelText = indiTitle;
    
    HUD.yOffset = -(self.bounds.size.height/10); //大约在黄金分割点
    
    [HUD show:YES];
}

- (void)showIndicatorHUD:(NSString *)indiTitle yOffset:(CGFloat)y
{
    MBProgressHUD *HUD = [self getIndicatorHUD];
    
    HUD.labelText = indiTitle;
    
    HUD.yOffset = y;
    
    [HUD show:YES];
}

- (void)hideIndicatorHUD
{
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:indicatorHUDTag];
    
    if (hud && [hud isKindOfClass:[MBProgressHUD class]])
    {
        [hud hide:YES];
    }
}

- (MBProgressHUD *)getIndicatorHUD
{
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:indicatorHUDTag];
    
    if (hud && [hud isKindOfClass:[MBProgressHUD class]])
    {
        return hud;
    }
    else
    {
        hud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:hud];
        hud.tag = indicatorHUDTag;
        
        //        if (IS_IPAD) {
        //            hud.labelFont =[UIFont systemFontOfSize:28];
        //        }
        
        hud.opacity = 0.6;
        hud.removeFromSuperViewOnHide = YES;
        return hud;
    }
    
}

- (void)showTextHUD:(NSString *)text
{
    MBProgressHUD *HUD = [self getTextHUD];
    
    HUD.detailsLabelText = text;
    
    HUD.yOffset = -(self.bounds.size.height/10); //大约在黄金分割点
    
    [HUD show:YES];
}

- (void)showTextHUD:(NSString *)text yOffset:(CGFloat)y
{
    MBProgressHUD *HUD = [self getTextHUD];
    
    HUD.detailsLabelText = text;
    
    HUD.yOffset = y; //大约在黄金分割点
    
    [HUD show:YES];
}

- (void)hideTextHUD
{
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:textHUDTag];
    
    if (hud && [hud isKindOfClass:[MBProgressHUD class]])
    {
        [hud hide:YES];
    }
}

- (MBProgressHUD *)getTextHUD
{
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:textHUDTag];
    
    if (hud && [hud isKindOfClass:[MBProgressHUD class]])
    {
        return hud;
    }
    else
    {
        hud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.tag = textHUDTag;
        hud.opacity = 0.6f;
        hud.removeFromSuperViewOnHide = YES;
        //        hud.shouldHideOnTouch = YES;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            hud.detailsLabelFont = [UIFont systemFontOfSize:30.0f];
            //            hud.maxBoxWidth = 800.0;
        }else{
            hud.detailsLabelFont = [UIFont systemFontOfSize:16.0f];
            //            hud.maxBoxWidth = 260.0;
        }
        
        hud.margin = 12.0f;
        hud.opacity = 0.6f;
        //        hud.boxCornerRadius = 6.0f;
        hud.animationType = MBProgressHUDAnimationZoom;
        
        return hud;
    }
}

@end
