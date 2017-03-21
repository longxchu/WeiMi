//
//  WeiMiBaseRequest.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"
#import "NetWorkManage.h"

@interface WeiMiBaseRequest()

@property (nonatomic, strong)MBProgressHUD *progress;

@end

@implementation WeiMiBaseRequest

//- (MBProgressHUD *)progress
//{
//    if (!_progress) {
//        
//        _progress =
//    }
//    return _progress;
//}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType
{
    return YTKRequestSerializerTypeHTTP;
}

- (void)clearAllCache
{
    NSFileManager *cacheFile = [NSFileManager defaultManager];
    
    NSError *error;
    
    if ([cacheFile removeItemAtPath:[self cacheBasePath] error:&error] != YES){
        
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    }
}

- (void)start
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [_progress hide:YES];
    
    if (![NetWorkManage sharedInstance].netWorkIsEnabled) {
        [self showWithMessage:@"啊哦,网络不太好哦" view:keyWindow];
        return;
    }
    [super start];
    
    if (self.showHUD) {
//        [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
        [self showWithMessage:nil view:keyWindow];
    }

}

- (void)requestCompleteFilter
{
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    [MBProgressHUD hideHUDForView:keyWindow animated:YES];
    
    [_progress hide:YES];
}

- (void)requestFailedFilter
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    [MBProgressHUD hideHUDForView:keyWindow animated:YES];
    [_progress hide:YES];

//    [self showWithMessage:@"啊哦,出错了" view:keyWindow];
    [self showWithMessage:self.error.description ? self.error.description:@"啊哦,出错了" view:keyWindow];
}

- (void)showWithMessage:(NSString *)message view:(UIView *)view;
{
    _progress = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if (message) {
        _progress.mode = MBProgressHUDModeText;
        _progress.labelText = message;
    }
    [_progress hide:YES afterDelay:5];
}
@end
