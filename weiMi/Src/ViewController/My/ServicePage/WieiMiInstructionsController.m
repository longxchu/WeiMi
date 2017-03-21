//
//  WieiMiInstructionsController.m
//  weiMi
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WieiMiInstructionsController.h"
#import "WeiMiBaseTableView.h"

@interface WieiMiInstructionsController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;

@end

@implementation WieiMiInstructionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self Inster];
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"使用帮助";
    self.popWithBaseNavColor = YES;
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
}

-(void)Inster{
    self.textView = [[UITextView alloc]init];
    self.textView.frame = CGRectMake(0,0, self.view.size.width, self.view.size.height);
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.contentInset = UIEdgeInsetsMake(64.f, 0.f, -8.f, 0.f);
    self.textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    self.textView.font = [UIFont fontWithName:@"AppleGothic" size:15.0];//设置字体名字和字体大小;
    //self.textView.editable = NO;
    //self.textView.delegate = self;
    //self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    self.textView.textAlignment = NSTextAlignmentLeft;
    //self.textView.scrollEnabled = YES;//是否可以拖动
    self.textView.text = @"\n首页购物:\n您可以在唯蜜生活商城自助购物。首页有六大分类，会员既可以从分类中寻找商品，也可以在搜索栏直接输入关键字查找商品哦。另外有限时秒杀活动，每天开始~\n\n社区社交:\n关注你喜欢的社区，自由发帖区。快来跟大家分享你独特的经历吧。更有美人体验专区等你来参与！\n\n积分商城:\n平时做任务可以获得积分，用积分可以在积分商城里面兑换我们为您准备的小礼物，数量有限，先到先得呀。\n\n我的信息:\n可以修改个人信息，查看我的等级和积分以及订单信息哦。\n\n有问题请及时拨打我们的客服热线哈~";
    [self.view addSubview:_textView];
    
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
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
