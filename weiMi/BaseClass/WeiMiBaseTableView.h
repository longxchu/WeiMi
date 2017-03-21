//
//  WeiMiBaseTableView.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiMiBaseTableView : UITableView

// 滑动隐藏键盘
@property (nonatomic, assign) BOOL scrollToHidenKeyBorad;

//工厂方法
+ (instancetype)tableView;
+ (instancetype)groupTableView;

//工具方法
- (void)scrollToBottom;

@end
