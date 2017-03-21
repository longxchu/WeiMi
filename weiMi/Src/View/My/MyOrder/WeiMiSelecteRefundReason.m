//
//  WeiMiSelecteRefundReason.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiSelecteRefundReason.h"

static CGFloat kCellHeight = 44.0f;
static WeiMiSelecteRefundReason *shared = nil;
@interface WeiMiSelecteRefundReason()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSMutableArray *_dataSource;
}
@property (nonatomic, strong)NSArray *pArray; //省的数组

@property (nonatomic,strong)NSArray *cArray; //城市的数组

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIView *backGrandView;


@end

@implementation WeiMiSelecteRefundReason

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[WeiMiSelecteRefundReason alloc]init];
    });
    return shared;
}

- (instancetype)init
{
    if (self = [super init]) {
        _dataSource = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.layer.cornerRadius = 8.0f;
    }
    return _tableView;
}

-(UIView *)backGrandView
{
    if (!_backGrandView)
    {
        _backGrandView = [[UIView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.delegate = self;
        [_backGrandView addGestureRecognizer:tap];
    }

    return _backGrandView;
}

- (void)showWithTitles:(NSArray *)titles
{
    [_dataSource setArray:titles];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.backGrandView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.backGrandView addSubview:self.tableView];
    
    self.backGrandView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    self.tableView.center = window.center;
    
    self.tableView.bounds = CGRectMake(0, 0, screenSize.width*0.8f, _dataSource.count * kCellHeight);
    self.tableView.center = self.backGrandView.center;
    self.tableView.scrollEnabled = NO;
    
    [window addSubview:self.backGrandView];
    
    [window bringSubviewToFront:self.backGrandView];
    [self showAnimation];
}

#pragma mark - Actions
-(void)tap:(id)sender
{
    [self dismissAnimation];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    // NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    return  YES;
}

#pragma mark - util
-(void)dismiss
{
    [self.tableView removeFromSuperview];
    [self.backGrandView removeFromSuperview];
    self.tableView = nil;
    self.backGrandView = nil;
}
#pragma mark animation
-(void)showAnimation
{
    self.tableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        
        self.tableView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
//        self.tableView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

-(void)dismissAnimation
{
    self.tableView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        
        self.tableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self dismiss];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = _dataSource[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    SeletedIndex block = self.seletedIndex;
    if (block) {
        block(indexPath.row, _dataSource[indexPath.row]);
    }
    [self dismissAnimation];
}

@end
