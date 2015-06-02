//
//  lycListViewController.m
//  blogapp
//
//  Created by aotuman on 13-10-31.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import "lycListViewController.h"
#import "lycCategory.h"
#import "lycNews.h"
#import "lycDetailViewController.h"
#import "lycIndexViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "lycNewCell.h"
#import "lycStripView.h"
#import "lycStripModel.h"

#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

#import "MBProgressHUD.h"
#import "OLGhostAlertView.h"

@implementation lycListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        
    }
    return self;
}

#pragma mark 初始化类别
- (id) initWithCategory:(lycCategory *)lyccategory{
    self=[super init];
    if (self!=nil) {
        _lyccategory=lyccategory;
        _page=1;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //下拉初始化
    [self setHeaderView];
   //幻灯
     [self changeSlide:self.view];
        //动态更改表格位置
    _tableViewList.frame=CGRectMake(0, _stripview.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-_stripview.frame.size.height);
    _tableViewList.separatorStyle=UITableViewCellSeparatorStyleNone;
    //标题
    self.title=_lyccategory.name;
       //上拉延迟2秒显示
    [self performSelector:@selector(setFooterView) withObject:self afterDelay:2];
    // [self.tableViewList reloadData];
    
}



- (void)viewDidCurrentView
{
    //通过类别cid 查询当前类别数据
    if (_arrNews==nil) {
         _arrNews=[NSMutableArray array];
        [self loadData:NO];
    }
   
    
   }

#pragma mark 下拉刷新
- (void)setHeaderView{
    if (_refreshHeaderView==nil) {
        _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
        _refreshHeaderView.delegate=self;
        [self.tableViewList addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];

}
#pragma mark 上拉刷新
- (void)setFooterView{
    float height=MAX(_tableViewList.contentSize.height, _tableViewList.frame.size.height);
   
    if (_refreshFooterView && [_refreshFooterView superview]) {
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              _tableViewList.frame.size.width,
                                              self.view.bounds.size.height);

    }else {
        _refreshFooterView=[[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0, height, _tableViewList.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate=self;
        [self.tableViewList addSubview:_refreshFooterView];
    }
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
   }
#pragma mark 移除头部
- (void)removeHeaderView{
    if (_refreshHeaderView&& [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView=nil;
}
#pragma mark 移除尾部
- (void)removeFooterView{
    if (_refreshFooterView&&[_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView=nil;
}


#pragma mark - 表格视图数据源代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arrNews.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *ListViewCellId = @"ListViewCellId";
    lycNewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];

    if (cell == nil) {
       // cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
        NSArray *arrs=[[NSBundle mainBundle] loadNibNamed:@"lycNewCell" owner:self options:nil];
        cell=[arrs objectAtIndex:0];
       // cell=[[lycNewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
    }
  
        lycNews *n=[_arrNews objectAtIndex:row];
        cell.title.font=[UIFont boldSystemFontOfSize:15.0];
      
        cell.title.text=n.title;
       // cell.desc.text=n.desc;

        //单元箭头按钮
        //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击跳转到具体信息
    NSInteger row=indexPath.row;
    lycNews *n=[_arrNews objectAtIndex:row];
    if (n) {
        lycDetailViewController *detail=[[lycDetailViewController alloc] init];
        detail.lycnews=n;
        [_pnavigation pushViewController:detail animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 下拉刷新
-(void)reloadTableViewDataSource{
    _reloading=YES;
     [self setFooterView];
}
-(void)doneLoadingTableViewData{
    _reloading=NO;
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableViewList];
    }
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableViewList];
         [self setFooterView];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }

}

- (NSDate *)egoRefreshTableDataSourceLastUpdated:(UIView *)view{
    return [NSDate date];
}

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
    
    if (aRefreshPos == EGORefreshHeader) {
        [self performSelector:@selector(headerRefresh) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter){
        [self performSelector:@selector(footerRefresh) withObject:nil afterDelay:2.0];
    }

    [self reloadTableViewDataSource];
}
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView *)view{
    return _reloading;
}
#pragma mark 加载下拉数据
- (void)headerRefresh{
    _page=_page-1>0?_page:1;
    [self loadData:NO];
}
#pragma mark 加载上拉数据
- (void)footerRefresh{
    _page++;
    [self loadData:NO];
}
#pragma mark 加载api数据
- (void)loadData:(BOOL)refresh{
    MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.mode=MBProgressHUDModeIndeterminate;
    [lycNews newsWithCid:_lyccategory.cid withPage:_page withBlock:^(NSArray *cats, NSError *error) {
        //0秒后关闭下拉
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
        if (cats.count>0) {
            _tableViewList.separatorStyle=UITableViewCellSeparatorStyleSingleLineEtched;
            _arrNews=[_arrNews arrayByAddingObjectsFromArray:cats];
            [self.tableViewList reloadData];
        }else{
            OLGhostAlertView *fail = [[OLGhostAlertView alloc] initWithTitle:@"亲，没有新闻！"];
            fail.style = OLGhostAlertViewStyleDark;
            fail.position=OLGhostAlertViewPositionCenter;
           // demo3.completionBlock = ^(void) {}
            [fail show];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

#pragma mark 幻灯片
- (void) changeSlide:(UIView *)view{
    if (_lyccategory.cid==1) {
        lycStripModel *model1,*model2,*model3,*model4;
        model1=[[lycStripModel alloc] initWithTitle:@"nihao" andDesc:@"nihao desctiopn" andPic:@"http://f.hiphotos.baidu.com/pic/w%3D310/sign=a76cf688c995d143da76e22243f18296/b21c8701a18b87d6c2b4b194060828381e30fd43.jpg"];
        model2=[[lycStripModel alloc] initWithTitle:@"nihao" andDesc:@"nihao desctiopn" andPic:@"image2.jpg"];
        model3=[[lycStripModel alloc] initWithTitle:@"nihao" andDesc:@"nihao desctiopn" andPic:@"image3.jpg"];
        model4=[[lycStripModel alloc] initWithTitle:@"nihao" andDesc:@"nihao desctiopn" andPic:@"http://f.hiphotos.baidu.com/pic/w%3D310/sign=a76cf688c995d143da76e22243f18296/b21c8701a18b87d6c2b4b194060828381e30fd43.jpg"];
        
        _stripview=[[lycStripView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 130) andArrStripModels:@[model1,model2,model3,model4]];
        //添加幻灯视图
        [view addSubview:_stripview];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
