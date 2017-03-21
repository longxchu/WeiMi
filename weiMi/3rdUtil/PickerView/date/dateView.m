//
//  dateView.m
//  UIPickView——Demo
//
//  Created by 钱趣多 on 16/8/23.
//  Copyright © 2016年 LPH. All rights reserved.
//

#import "dateView.h"
#import "LPHPickerHeader.h"
#import "NSCalendar+LPH.h"

@interface dateView()<UIPickerViewDelegate,UIPickerViewDataSource>
/** 1.年 */
@property (nonatomic, assign)NSInteger year;
/** 2.月 */
@property (nonatomic, assign)NSInteger month;
/** 3.日 */
@property (nonatomic, assign)NSInteger day;

@property(nonatomic,strong)UIPickerView  * pickerView;
@property(nonatomic,strong)UIView * baseView;

@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIButton * cancelBtn;
@property(nonatomic,strong)UIButton * sureBtn;

@property(nonatomic,strong)NSString * dateString;
@end

@implementation dateView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
-(void)setUI{

    _heightPickerComponent = 28;
    
    _year  = [NSCalendar currentYear];
    _month = [NSCalendar currentMonth];
    _yearLeast = 1970;
    _yearSum   = _year - _yearLeast + 1;
    
    _day   = [NSCalendar currentDay];
    [self addSubview:self.baseView];
//    [self addTitleAndBtn];
    [self.baseView addSubview:self.pickerView];
    
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    
    [self.pickerView selectRow:(_year - _yearLeast) inComponent:0 animated:NO];
    [self.pickerView selectRow:(_month - 1) inComponent:1 animated:NO];
    [self.pickerView selectRow:(_day - 1) inComponent:2 animated:NO];
    
}

- (void)selectYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
{
    [self.pickerView selectRow:(year - _yearLeast) inComponent:0 animated:NO];
    [self.pickerView selectRow:(month - 1) inComponent:1 animated:NO];
    [self.pickerView selectRow:(day - 1) inComponent:2 animated:NO];
    
    _year = year;
    _month = month;
    _day = day;
    _dateString = [NSString stringWithFormat:@"%d-%d-%d",self.year,self.month,self.day];
    
    if ([self.delegate respondsToSelector:@selector(dateViewWithTitle:)]) {
        [self.delegate dateViewWithTitle:_dateString];
    }
    
    if ([self.delegate respondsToSelector:@selector(dateViewWithYear:month:day:)]) {
        [self.delegate dateViewWithYear:_year month:_month day:_day];
    }
}
#pragma mark  pickerView的代理方法
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.yearSum;
    }else if(component == 1) {
        return 12;
    }else {
        NSInteger yearSelected = [pickerView selectedRowInComponent:0] + self.yearLeast;
        NSInteger monthSelected = [pickerView selectedRowInComponent:1] + 1;
        return  [NSCalendar getDaysWithYear:yearSelected month:monthSelected];
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            break;
        case 1:
            [pickerView reloadComponent:2];
        default:
            break;
    }
    [self reloadData];
    
    _dateString = [NSString stringWithFormat:@"%d-%d-%d",self.year,self.month,self.day];

    if ([self.delegate respondsToSelector:@selector(dateViewWithTitle:)]) {
        [self.delegate dateViewWithTitle:_dateString];
    }
    
    if ([self.delegate respondsToSelector:@selector(dateViewWithYear:month:day:)]) {
        [self.delegate dateViewWithYear:_year month:_month day:_day];
    }
}
- (void)reloadData
{
    self.year  = [self.pickerView selectedRowInComponent:0] + self.yearLeast;
    self.month = [self.pickerView selectedRowInComponent:1] + 1;
    self.day   = [self.pickerView selectedRowInComponent:2] + 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *text;
    if (component == 0) {
        text =  [NSString stringWithFormat:@"%d", row + 1970];
    }else if (component == 1){
        text =  [NSString stringWithFormat:@"%d", row + 1];
    }else{
        text = [NSString stringWithFormat:@"%d", row + 1];
    }
    _dateString = [NSString stringWithFormat:@"%d-%d-%d",self.year,self.month,self.day];
    
    
    
//    if ([self.delegate respondsToSelector:@selector(dateViewWithTitle:)]) {
//        [self.delegate dateViewWithTitle:_dateString];
//    }
//    
//    if ([self.delegate respondsToSelector:@selector(dateViewWithYear:month:day:)]) {
//        [self.delegate dateViewWithYear:_year month:_month day:_day];
//    }
    
    return text;
}

-(void)addTitleAndBtn{
    NSArray * btnTitle = @[@"取消",@"确定"];
    for (int i = 0; i < 2; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnTitle[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake((i == 0)?0:(Width - 60), 0, 60, 40);
        if (i == 0) {
            _cancelBtn = btn;
        }else
            _sureBtn = btn;
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:btn
         ];
    }
    //创建分割线
    CGFloat gap = 25;
    CGRect frame = CGRectMake(0, (self.pickerView.frame.size.height - gap)/2 + gap, Width, 0.5);
    [self.pickerView addSubview:[self createLineViewWithFrame:frame]];
    
    CGRect frameTopLine = CGRectMake(0,0, Width, 0.5);
    [self.baseView addSubview:[self createLineViewWithFrame:frameTopLine]];
    
    CGRect frameBottomLine = CGRectMake(0,40, Width, 0.5);
    [self.baseView addSubview:[self createLineViewWithFrame:frameBottomLine]];
    
}
-(UIView *)createLineViewWithFrame:(CGRect )frame{
    UIView * line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = grayColorWith(150);
    return line;
}
-(void)btnClick:(UIButton *)btn{
    if (btn == _cancelBtn) {
        [self hiden];
    }else{
        NSLog(@"确定");
        if ([self.delegate respondsToSelector:@selector(dateViewWithTitle:)]) {
            [self.delegate dateViewWithTitle:_dateString];
        }
        [self hiden];
    }
    btn.selected = !btn.selected;
}
-(UIView *)baseView{
    if (!_baseView) {
        _baseView = [[UIView alloc]initWithFrame:self.bounds];
        _baseView.backgroundColor = [UIColor whiteColor];
    }
    return _baseView;
}
-(UIPickerView *)pickerView{
    if (!_pickerView) {
//        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, Width, self.baseView.frame.size.height - 40)];
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, Width, self.baseView.frame.size.height)];
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}
-(void)hiden{
    [self removeFromSuperview];
}
-(void)show{
    [self setUI];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
