//
//  lycSlideSwitchViewController.m
//  blogapp
//
//  Created by aotuman on 13-10-31.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import "lycSlideSwitchViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "lycListViewController.h"
#import "lycCategory.h"
#import "lycStripView.h"
#import "lycStripModel.h"
#import "lycFunc.h"
#import "lycNetwork.h"

#import "lycLeftMenuViewController.h"
#import "MBProgressHUD.h"


@implementation lycSlideSwitchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
       
        
    }
    return self;
}

#pragma mark 旋转幻灯兼容
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight) {
       // self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [_arrList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            lycListViewController *l=(lycListViewController *)obj;
            l.stripview.frame=CGRectMake(0,0,self.view.frame.size.width, 130);
        }];
    }else{
        [_arrList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            lycListViewController *l=(lycListViewController *)obj;
            l.stripview.frame=CGRectMake(0,0,self.view.frame.size.width, 130);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //隐藏tool
    [self.navigationController setToolbarHidden:YES];
    if (self.mm_drawerController.leftDrawerViewController==nil) {
        //显示left
        if (!_leftMenu) {
            _leftMenu=[[lycLeftMenuViewController alloc] init];
        }
        [self.mm_drawerController setLeftDrawerViewController:_leftMenu];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   //判断网络
  
   // lycAppDelegate *appDlg = (lycAppDelegate *)[[UIApplication sharedApplication] delegate];

    if ([[lycNetwork defaultCenter] isReach]) {
        NSLog(@"network success") ;
    }else{
        NSLog(@"no network");
    }
    //ios7兼容性
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.view.backgroundColor=[UIColor whiteColor];
    }
    
    //NSLog(@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]);
    self.title = @"凹凸曼博客";
    
    self.slideSwitchView.tabItemNormalColor = [SUNSlideSwitchView colorFromHexRGB:@"868686"];
    //self.slideSwitchView.tabItemSelectedColor = [SUNSlideSwitchView colorFromHexRGB:@"bb0b15"];
   // self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow"] stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    
    //按钮滑动
    UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightSideButton addTarget:self action:@selector(rightSide) forControlEvents:UIControlEventTouchUpInside];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"] forState:UIControlStateNormal];
   // [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"]  forState:UIControlStateHighlighted];
    rightSideButton.frame = CGRectMake(0, 0, 20.0f, 38.0f);
    self.slideSwitchView.rigthSideButton = rightSideButton;
    self.slideSwitchView.rigthSideButton.hidden=YES;

    //导航条
    //左边按钮 右边按钮
    lycFunc *func=[[lycFunc alloc] init];
    [func navLeftButton:self withAction:@selector(clickLeftAction:)];
    [func navRightButton:self withAction:@selector(clickRightAction:)];
   
    
    if (_arrList.count==0) {
//        _activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        _activityView.hidesWhenStopped=YES;
//        [self.view addSubview:_activityView];
//        
//        _activityView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        [self loadData];
    }
    //toobar
    // 托盘
//    UIBarButtonItem *one=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
//    
//    UIBarButtonItem *two=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
//    NSArray *array=[NSArray arrayWithObjects:one,two, nil];
//    [self setToolbarItems:array animated:YES];


}

#pragma mark 加载数据
- (void) loadData{
   // [_activityView startAnimating];
    MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.mode=MBProgressHUDModeIndeterminate;
    //动态调用分类
    [lycCategory categoryWithBlock:^(NSArray *cats, NSError *error) {
        if (error) {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 100, 20)];
            label.text=@"加载失败！";
            [self.view addSubview:label];
        }else{
            
            //  _arrList=cats;
            // [self setArrList:cats];
            //栏目类别
            __block lycListViewController *listv;
            _arrList=[[NSMutableArray alloc] init];
            [cats enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                listv=[[lycListViewController alloc] initWithCategory:obj];
                listv.pnavigation=self.navigationController;
                
                [_arrList addObject:listv];
                
            }];
         
            [self viewDidLoad];
            self.slideSwitchView.rigthSideButton.hidden=NO;
          
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
       // [_activityView stopAnimating];
       // [_activityView removeFromSuperview];
          [self.slideSwitchView buildUI];
      
    }];
}
#pragma mark   内容切换滑动
- (void) rightSide{
    NSInteger tag=[self.slideSwitchView userSelectedChannelID]+1;
    if(tag<100+_arrList.count){
        UIButton *tabbutton=(UIButton *)[self.slideSwitchView.topScrollView viewWithTag:tag];
        [self.slideSwitchView selectNameButton:tabbutton];
    }
}

#pragma mark 按钮左点事件 滑出左侧视图
- (void)clickLeftAction:(id) sender{
    lycIndexViewController *drawerController=(lycIndexViewController * )self.navigationController.mm_drawerController;
    [drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES
                            completion:nil];
}

#pragma mark 按钮右点事件 右边视图滑动
- (void)clickRightAction:(id) sender{
    lycIndexViewController *drawerController = (lycIndexViewController *)self.navigationController.mm_drawerController;
    [drawerController toggleDrawerSide:MMDrawerSideRight animated:YES
                            completion:nil];
    
}


#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
   
    return _arrList.count;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    
    
        return [_arrList objectAtIndex:number];
    
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    lycIndexViewController *drawerController = (lycIndexViewController *)self.navigationController.mm_drawerController;
    [drawerController panGestureCallback:panParam];
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panRightEdge:(UIPanGestureRecognizer *)panParam{
    lycIndexViewController *drawerController = (lycIndexViewController * )self.navigationController.mm_drawerController;
    [drawerController panGestureCallback:panParam];
}
- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    lycListViewController *vc = nil;
    vc=[_arrList objectAtIndex:number];

    [vc viewDidCurrentView];
}

#pragma mark - 内存报警

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
