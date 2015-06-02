//
//  lycLeftMenuViewController.m
//  blogapp
//
//  Created by aotuman on 13-10-31.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//


#import "lycLeftMenuViewController.h"
#import "lycSlideSwitchViewController.h"
#import "lycMsgViewController.h"
#import "UIViewController+MMDrawerController.h"

@implementation lycLeftMenuViewController

#pragma mark - 控制器初始化方法

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _slideSwitchVC = [[lycSlideSwitchViewController alloc] init];
      //  self.navSlideSwitchVC = [[UINavigationController alloc] initWithRootViewController:_slideSwitchVC];

    
    }
    return self;
}

- (void)setupUI
{

}

#pragma mark - 控制器方法

#pragma mark - 视图加载方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //默认选择的cell
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableViewLeft selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionTop];
    
}


#pragma mark - 表格视图数据源代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    NSString *LeftSideCellId = @"LeftSideCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LeftSideCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LeftSideCellId];
    }
    if (section == 0) {
        if (row == 0) {
            cell.textLabel.text = @"首页";
             cell.selected=1;
            [self selectd:cell];

        } else if (row == 1) {
            cell.textLabel.text = @"留言";
        }
        
    }
    
    return  cell;
}

#pragma mark 改变选中的cell 改变背景色
- (void)selectd:(UITableViewCell *)cell{
    if (cell.selected) {
        UIView *v=[[UIView alloc] init];
        v.backgroundColor=[UIColor brownColor];
        cell.selectedBackgroundView=v;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int section = indexPath.section;

    int row = indexPath.row;
//改变选中的cell的背景色
    UITableViewCell *cell=(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self selectd:cell];
   

    
    if (section == 0) {
        if (row == 0) {
            //首页
            
            if (!_commonNAV) {
               
                _slideSwitchVC = [[lycSlideSwitchViewController alloc] init];
                _commonNAV = [[UINavigationController alloc] initWithRootViewController:_slideSwitchVC];
            }
            //[self.mm_drawerController setCenterViewController:self.navSlideSwitchVC
             //                              withCloseAnimation:NO completion:nil];
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
                if (finished) {
                    
                    [self.mm_drawerController setCenterViewController:_commonNAV];
                  
                }
            }];
        } else if (row == 1) {
            //其他页面
            if (!_msgVC) {
                _msgVC=[[lycMsgViewController alloc] init];
                
                if (! _commonNAV) {
                    _commonNAV = [[UINavigationController alloc] initWithRootViewController:_msgVC];
                }
               
                
                
            }
            
            [_commonNAV pushViewController:_msgVC animated:YES];
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
                if (finished) {
                    
                    [self.mm_drawerController setCenterViewController:_commonNAV];
                    
                }
            }];
        }
    }
    
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 销毁内存方法

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
