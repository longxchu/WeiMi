//
//  CityView.m
//  UIPickView——Demo
//
//  Created by 钱趣多 on 16/8/22.
//  Copyright © 2016年 LPH. All rights reserved.
//


#import "CityView.h"
#import "LPHPickerHeader.h"

@interface CityView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIPickerView * picker;
@property(nonatomic,strong)NSArray * rootArr;
@property(nonatomic,strong)NSMutableArray * cityArr;
@property(nonatomic,strong)NSMutableArray * areaArr;
@property(nonatomic,assign)NSInteger num0;//第一列选择的是第几个元素
@property(nonatomic,assign)NSInteger num1;//第二列选择的是第几个元素
@property(nonatomic,assign)NSInteger num2;//第三列选择的是第几个元素

@property(nonatomic,strong)NSString * string0;//第一列选择的字符串
@property(nonatomic,strong)NSString * string1;//第二列
@property(nonatomic,strong)NSString * string2;//第三列

@property(nonatomic,strong)UIView * backView;
@property(nonatomic,strong)UIView * baseView;

@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIButton * cancelBtn;
@property(nonatomic,strong)UIButton * sureBtn;
@end
@implementation CityView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setUI{
    [self addSubview:self.backView];
    [self.backView addSubview:self.baseView];
    [self.baseView addSubview: self.picker];
    [self freshFrame];//创建按钮和显示标题
}
-(void)freshFrame{
    [self.baseView addSubview:self.titleLabel];
    self.picker.frame = CGRectMake(0, 40, self.picker.frame.size.width, self.picker.frame.size.height);
    NSArray * btnArr = @[@"确定",@"取消"];
    for (int i = 0; i < 2; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 1) {
            _cancelBtn = btn;
        }else
            _sureBtn = btn;
        btn.frame = CGRectMake((Width - 2*Offset)/2 * i, CGRectGetMaxY(self.picker.frame), (Width - 2*Offset)/2, 40);
        [self.baseView addSubview:btn];
    }
    //创建分割线
     CGFloat gap = 25;
    CGRect frame = CGRectMake(0, (self.picker.frame.size.height - gap)/2 + gap, Width, 0.5);
    [self.picker addSubview:[self createLineViewWithFrame:frame]];
    
    CGRect frameTopLine = CGRectMake(0,40, Width, 0.5);
    [self.baseView addSubview:[self createLineViewWithFrame:frameTopLine]];
    
    CGRect frameBottomLine = CGRectMake(0,self.baseView.frame.size.height - 40, Width, 0.5);
    [self.baseView addSubview:[self createLineViewWithFrame:frameBottomLine]];
    
    CGRect frameMidLine = CGRectMake((Width - 2*Offset)/2 , self.baseView.frame.size.height - 40, 0.5, 40);
    [self.baseView addSubview:[self createLineViewWithFrame:frameMidLine]];
}
-(UIView *)createLineViewWithFrame:(CGRect )frame{
    UIView * line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = grayColorWith(150);
    return line;
}

#pragma mark 取消或确定的代理方法
-(void)btnClick:(UIButton * )btn{
    if (btn == _cancelBtn) {
        [self hiden];
    }else{
        [self hiden];
        if ([self.delegate respondsToSelector:@selector(cityViewWithTitle:)]) {
            [self.delegate cityViewWithTitle:_titleLabel.text];
        }
        if ([self.delegate respondsToSelector:@selector(cityviewWIthProvince:city:district:)]) {
            
            [self.delegate cityviewWIthProvince:_string0 city:_string1 district:_string2];
        }
    }
}
#pragma mark pickerView的代理方法
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray * arr = [self.rootArr[self.num0] objectForKey:@"cities"];
    if (component == 0) {
        return _rootArr.count;
    }else if (component == 1){
        return [arr count];
    }
    
    if (arr[self.num1]) {
        return [[arr[self.num1] objectForKey:@"areas"] count];
    }
    return 0;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray * arr = [self.rootArr[self.num0] objectForKey:@"cities"];
    if (component == 0) {
        return [_rootArr[row] objectForKey:@"state"];
    }else if (component == 1){
        return [arr[row] objectForKey:@"city"];
    }
    return [arr[self.num1] objectForKey:@"areas"][row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _num0 = row;
        _num1 = 0;
        _num2 = 0;
        NSArray * arr = [self.rootArr[_num0] objectForKey:@"cities"];
        NSArray * arr2  = [arr[_num1] objectForKey:@"areas"];
        _string0 = [NSString stringWithFormat:@"%@",[_rootArr[row] objectForKey:@"state"]];
        _string1 = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"city"]];
        if (arr2.count) {
            _string2 = [NSString stringWithFormat:@"%@",arr2[_num2]];
        }else
            _string2 = @"";
        [self.picker reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [self.picker reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else if (component == 1){
        _num1= row;
        _num2 = 0;
        NSArray * arr = [self.rootArr[_num0] objectForKey:@"cities"];
        NSArray * arr2  = [arr[_num1] objectForKey:@"areas"];
        _string1 = [NSString stringWithFormat:@"%@",[arr[_num1] objectForKey:@"city"]];
        if (arr2.count) {
            _string2 = [NSString stringWithFormat:@"%@",arr2[_num2]];
        }else
            _string2 = @"";
        [self.picker reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else{
        _num2  = row;
        NSArray * arr = [self.rootArr[_num0] objectForKey:@"cities"];
        NSArray * arr2  = [arr[_num1] objectForKey:@"areas"];
        if (arr2.count) {
            _string2 = [NSString stringWithFormat:@"%@",arr2[_num2]];
        }else
            _string2 = @"";
    }
    _titleLabel.text = [NSString stringWithFormat:@"%@%@%@",_string0,_string1,_string2];
}
-(UIPickerView *)picker{
    if (!_picker) {
        _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, Width - Offset*2, 160)];
        _picker.delegate = self;
        _picker.dataSource = self;
    }
    return _picker;
}
-(UIView *)baseView{
    if (!_baseView) {
        _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width - Offset*2, 240)];
        _baseView.center = self.backView.center;
        _baseView.backgroundColor = [UIColor whiteColor];
    }
    return _baseView;
}
-(NSArray *)rootArr{
    if (!_rootArr) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
        _rootArr = [[NSArray alloc]initWithContentsOfFile:path];
    }
    return _rootArr;
}
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _backView.backgroundColor =[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:0.5];
    }
    return _backView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width - 2*Offset, 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _string0 = [NSString stringWithFormat:@"%@",[self.rootArr[0] objectForKey:@"state"]];
        _string1 = [NSString stringWithFormat:@"%@",[[[self.rootArr[0] objectForKey:@"cities"] objectAtIndex:0] objectForKey:@"city"]];
        _titleLabel.text = [NSString stringWithFormat:@"%@%@",_string0,_string1];
    }
    return _titleLabel;
}
-(void)hiden{
    [self removeFromSuperview];
}
-(void)show{
    [self setUI];
    [self.superview addSubview:self];
}
@end
