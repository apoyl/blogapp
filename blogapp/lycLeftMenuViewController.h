//
//  lycLeftMenuViewController.h
//  blogapp
//
//  Created by aotuman on 13-10-31.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class lycSlideSwitchViewController,lycMsgViewController;

@interface lycLeftMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) IBOutlet UITableView *tableViewLeft;
@property (nonatomic, strong) lycSlideSwitchViewController *slideSwitchVC;
@property (nonatomic, strong) lycMsgViewController *msgVC;

@property (nonatomic,strong) IBOutlet  UINavigationController  *commonNAV;

#pragma mark 改变选中的cell 改变背景色
- (void)selectd:(UITableViewCell *)cell;
@end
