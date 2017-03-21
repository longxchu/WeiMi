//
//  WeiMiBaseCommonHeader.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

@protocol WeiMiCommonHeaderDelegate <NSObject>

- (void)didSelectedBtn;

@end

typedef void (^OnChangeBtnHandler) ();

@interface WeiMiCommonHeader : WeiMiBaseView

@property (nonatomic, weak) id <WeiMiCommonHeaderDelegate> delegate;
@property (nonatomic, copy) OnChangeBtnHandler onChangeBtnHandler;

- (void)setTitle:(NSString *)title;

@end
