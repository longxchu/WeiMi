//
//  WeiMiBaseTableView.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseTableView.h"

@implementation WeiMiBaseTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        [self setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
        self.scrollEnabled = YES;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor bgColor_view];
        self.backgroundView = nil;
    }
    return self;
}

+ (instancetype)tableView
{
    WeiMiBaseTableView *_tableView = [[WeiMiBaseTableView alloc] initWithFrame:CGRectZero
                                                                           style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:view];
    return _tableView;
}

+ (instancetype)groupTableView
{
    WeiMiBaseTableView *_tableView = [[WeiMiBaseTableView alloc] initWithFrame:CGRectZero
                                                                           style:UITableViewStyleGrouped];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    return _tableView;
}

/** 改变UITableView的headerView背景颜色为透明色*/
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}


/** 改变UITableView的footerView背景颜色为透明色*/
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)scrollToBottom
{
    NSInteger sectionCount = [self.dataSource numberOfSectionsInTableView:self];
    NSInteger lastSectionRowCount = [self.dataSource tableView:self numberOfRowsInSection:sectionCount-1];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastSectionRowCount-1 inSection:sectionCount-1];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)setScrollToHidenKeyBorad:(BOOL)scrollToHidenKeyBorad
{
    _scrollToHidenKeyBorad = scrollToHidenKeyBorad;
    if (_scrollToHidenKeyBorad) {
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
//        [self addObserver:self forKeyPath:@"indexPathForSelectedRow" options:NSKeyValueObservingOptionNew context:NULL];
    }
}

/**
 *  监听方法
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    [self refreshChangeState];
}
/**
 *  通过监听当前scrollView的状态,回收键盘
 */
- (void)refreshChangeState{
//    CGFloat offsetY = self.contentOffset.y;
    // 用户是否在拖动
    if (self.dragging) {
        [[self cellsForTableView] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[UITableViewCell class]]) {
                for (UIView *view in ((UITableViewCell *)obj).contentView.subviews) {
                    [view resignFirstResponder];
                }
            }
        }];
    }
}


- (NSArray *)cellsForTableView
{
    NSInteger sections = self.numberOfSections;
    NSMutableArray *cells = [[NSMutableArray alloc]  init];
    for (int section = 0; section < sections; section++) {
        NSInteger rows =  [self numberOfRowsInSection:section];
        for (int row = 0; row < rows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
            if (cell) {[cells addObject:cell];}
        }
    }
    return cells;
}

- (void)dealloc
{
    if (_scrollToHidenKeyBorad) {
        [self removeObserver:self forKeyPath:@"contentOffset"];
//        [self removeObserver:self forKeyPath:@"indexPathForSelectedRow"];
    }
}

@end
