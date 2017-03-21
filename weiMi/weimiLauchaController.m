//
//  weimiLauchaController.m
//  weiMi
//
//  Created by Mac on 16/12/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "weimiLauchaController.h"
#import "Lauchs.h"
#import "WeiMiMainViewController.h"
@interface weimiLauchaController ()<UIScrollViewDelegate>

@end

@implementation weimiLauchaController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //布局页面
    [self lanyoutSubviews];
}

-(void)lanyoutSubviews {
    [self setUpScrollView];//布局scrollView
//    [self setUpPageControl];//布局pageControl
}

- (void)setUpScrollView {
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    //设置内容区域大小
    scroll.contentSize = CGSizeMake(kScreenWidth * KImageCount, kScreenHeight);
    //整页滑动
    scroll.pagingEnabled = YES;
    //不显示水平滑条
    scroll.showsHorizontalScrollIndicator = NO;
    //设置代理
    scroll.delegate = self;
    
    scroll.tag = kScrollTag;
    [self.view addSubview:scroll];
    
    //放置引导图片
    for (int i = 0; i < KImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",kPictureName,i+1]]];
        [scroll addSubview:imageView];
        //最后一张添加轻拍手势
        if (i == KImageCount - 1) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:tap];
            //打开imageView的用户交互
            imageView.userInteractionEnabled = YES;
        }
    }
    
}


//- (void)setUpPageControl{
//    UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake((kScreenWidth - 200) / 2, kScreenHeight - 40, 200, 20)];
//    //设置总页数
//    page.numberOfPages = KImageCount;
//    //当前点颜色
//    page.currentPageIndicatorTintColor = [UIColor whiteColor];
//    //其余点颜色
//    page.pageIndicatorTintColor = [UIColor grayColor];
//    page.tag = kPageControlTag;
//    [self.view addSubview:page];
//}




#pragma mark -- UIScrollViewDelegate-
//触发时机:scroll已经结束减速
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:kPageControlTag];
//    page.currentPage =  scrollView.contentOffset.x / kScreenWidth;
//}


#pragma mark --轻拍进入主页面
- (void)handleTap:(UITapGestureRecognizer *)tap {
    //当你点击最后一张时，意味着用户引导页已结束。将对应key保存到 NSUserDefaults
    NSUserDefaults *faults = [NSUserDefaults standardUserDefaults];
    [faults setBool:YES forKey:FIPST];
    //立即更新,立即执行保存操作。
    [faults synchronize];
    
    //进入程序主界面
    WeiMiMainViewController *mainVC = [[WeiMiMainViewController alloc]init];
    //更改window的根视图控制器 为主界面的视图控制器mainVC
    [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES; // 返回NO表示要显示，返回YES将不显示
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
