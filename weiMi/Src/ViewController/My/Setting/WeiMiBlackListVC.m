//
//  WeiMiBlackListVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/12.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBlackListVC.h"
#import "WeiMiBaseTableView.h"
#import "ChineseString.h"
#import "WeiMiBaseSearchBar.h"


@interface WeiMiBlackListVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchDisplayDelegate>
{
    NSMutableArray *_searchResult;
    NSArray *_stringsToSort;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property (nonatomic, strong) UILabel *sectionTitleView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchControl;

@end

@implementation WeiMiBlackListVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _searchResult = [NSMutableArray new];
        _stringsToSort = [NSArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    _tableView.frame = self.contentFrame;
    
    _tableView.tableHeaderView = self.searchBar;
    _searchControl = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    _searchControl.searchResultsDelegate = self;
    _searchControl.searchResultsDataSource = self;
    _searchControl.delegate = self;
    
    self.sectionTitleView = ({
        UILabel *sectionTitleView = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, (SCREEN_HEIGHT-100)/2,100,100)];
        sectionTitleView.textAlignment = NSTextAlignmentCenter;
        sectionTitleView.font = [UIFont boldSystemFontOfSize:60];
        sectionTitleView.textColor = HEX_RGB(BASE_COLOR_HEX);
        sectionTitleView.backgroundColor = [UIColor whiteColor];
        sectionTitleView.layer.cornerRadius = 6;
        sectionTitleView.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
        _sectionTitleView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        sectionTitleView;
    });
    [self.navigationController.view addSubview:self.sectionTitleView];
    self.sectionTitleView.hidden = YES;
    
    
    _stringsToSort = [NSArray arrayWithObjects:
                              @"2014",@"a1",@"100",@"中国",@"暑假作业",
                              @"键盘", @"鼠标",@"hello",@"world",@"b1",
                              nil];
    self.indexArray = [ChineseString IndexArray:_stringsToSort];
    self.letterResultArr = [ChineseString LetterSortArray:_stringsToSort];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"黑名单";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        //        if (_saveName) {
        //            [[WeiMiPageSkipManager mineRouter] callBackToVC:@"WeiMiModifyNameVC" params:@[_name]];
        //        }
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索";
        //        _searchBar.layer.borderColor = kGrayColor.CGColor;
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT);
    }
    return _searchBar;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.scrollToHidenKeyBorad = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

#pragma mark - Actions

#pragma mark - UISearchDisplayDelegate
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller NS_DEPRECATED_IOS(3_0,8_0)
{
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller NS_DEPRECATED_IOS(3_0,8_0)
{
    UIButton *cancelBtn = [controller.searchBar valueForKeyPath:@"cancelButton"];
    if(cancelBtn)
    {
        [cancelBtn setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateHighlighted];
        [cancelBtn setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateSelected];
    }
}

#pragma mark - UITableViewDataSource
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([_searchControl isActive]) {
        return nil;
    }
    return self.indexArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([_searchControl isActive]) {
        return nil;
    }
    NSString *key = [self.indexArray objectAtIndex:section];
    return key;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_searchControl isActive]) {
        return 1;
    }
    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_searchControl isActive]) {
        return _searchResult.count;
    }
    return [[self.letterResultArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
        
    }
    if ([_searchControl isActive]) {
        cell.textLabel.text = _searchResult[indexPath.row];
    }else
    {
        cell.textLabel.text = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self showSectionTitle:title];
    return index;
}

#pragma mark - private
- (void)timerHandler:(NSTimer *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3 animations:^{
            self.sectionTitleView.alpha = 0;
        } completion:^(BOOL finished) {
            self.sectionTitleView.hidden = YES;
        }];
    });
}

-(void)showSectionTitle:(NSString*)title{
    [self.sectionTitleView setText:title];
    self.sectionTitleView.hidden = NO;
    self.sectionTitleView.alpha = 1;
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


#pragma mark - UITabelViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [UILabel new];
    lab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lab.text = [NSString stringWithFormat:@"  %@", [self.indexArray objectAtIndex:section]];
    lab.textColor = kGrayColor;
    return lab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_searchControl isActive]) {
        return 1.0f;
    }
    return 25.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:[[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]
                                                   delegate:nil
                                          cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    searchBar.showsCancelButton = YES;
//    UIButton *cancelButton;
//    
//}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
    
    _searchResult = [NSMutableArray arrayWithArray:[_stringsToSort filteredArrayUsingPredicate:resultPredicate]];
}

#pragma mark - UISearchDisplayController delegate methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]                                       objectAtIndex:[self.searchDisplayController.searchBar                                                      selectedScopeButtonIndex]]];
    
    return YES;
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles]                                       objectAtIndex:searchOption]];
    
    return YES;
    
}

#pragma mark - Constraints
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

@end
