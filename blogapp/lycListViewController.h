//
//  lycListViewController.h
//  blogapp
//
//  Created by aotuman on 13-10-31.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOViewCommon.h"
@class lycCategory,lycStripView,EGORefreshTableFooterView,EGORefreshTableHeaderView;
@interface lycListViewController : UIViewController<EGORefreshTableDelegate,UITableViewDataSource, UITableViewDelegate>
//视图表格
@property (nonatomic, strong) IBOutlet UITableView *tableViewList;
//新闻分类
@property (strong,nonatomic) lycCategory *lyccategory;
//信息列表数组
@property (strong,nonatomic) NSArray *arrNews;
//幻灯视图
@property (strong,nonatomic) lycStripView   *stripview;
//父类导航
@property (strong,nonatomic) UINavigationController *pnavigation;
//下拉刷新
@property (strong,nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
//上拉刷新
@property (strong,nonatomic) EGORefreshTableFooterView *refreshFooterView;
@property (assign,nonatomic) BOOL reloading;
//分页
@property (assign,nonatomic) NSUInteger page;
- (void)viewDidCurrentView;
#pragma mark 初始化类别
- (id) initWithCategory:(lycCategory *)lyccategory;

#pragma mark 加载数据
- (void)loadData:(BOOL)refresh;

#pragma mark 下拉刷新
- (void) headerRefresh;
- (void) footerRefresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
