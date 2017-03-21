//
//  dateView.h
//  UIPickView——Demo
//
//  Created by 钱趣多 on 16/8/23.
//  Copyright © 2016年 LPH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol dateViewDelegate <NSObject>
-(void)dateViewWithTitle:(NSString * )string;

-(void)dateViewWithYear:(NSInteger )year month:(NSInteger)month day:(NSInteger)day;

@end
@interface dateView : UIView
/** 1.最小的年份，default is 1900 */
@property (nonatomic, assign)NSInteger yearLeast;
/** 2.显示年份数量，default is 200 */
@property (nonatomic, assign)NSInteger yearSum;
/** 3.中间选择框的高度，default is 28*/
@property (nonatomic, assign)CGFloat heightPickerComponent;
@property(nonatomic,assign)id<dateViewDelegate>delegate;

- (void)selectYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

-(void)show;
-(void)hiden;
-(void)setUI;
@end
