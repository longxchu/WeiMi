//
//  WeiMiSearchBar.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

@protocol WeiMiSearchBarDelegate <NSObject>

@optional
- (BOOL)searchBarTextFieldShouldBeginEditing:(UITextField *)textField;

@end

@interface WeiMiSearchBar : WeiMiBaseView

@property (nonatomic, weak) id <WeiMiSearchBarDelegate> delegate;

@end
