//
//  CityView.h
//  UIPickView——Demo
//
//  Created by 钱趣多 on 16/8/22.
//  Copyright © 2016年 LPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityViewDelegate <NSObject>
-(void)cityViewWithTitle:(NSString * )string;
- (void)cityviewWIthProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;
@end
@interface CityView : UIView
@property(nonatomic,assign)id<CityViewDelegate>delegate;
-(void)show;
-(void)hiden;
-(void)setUI;
@end
