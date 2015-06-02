//
//  lycSlideSwitchViewController.h
//  blogapp
//
//  Created by aotuman on 13-10-31.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUNSlideSwitchView.h"
#import "lycIndexViewController.h"
#import "lycLeftMenuViewController.h"

@interface lycSlideSwitchViewController : UIViewController<SUNSlideSwitchViewDelegate>

@property (nonatomic, strong) IBOutlet SUNSlideSwitchView *slideSwitchView;

//存放类别视图
@property (strong,nonatomic)  NSMutableArray  *arrList;

@property (strong,nonatomic) UIActivityIndicatorView *activityView;

@property (strong,nonatomic) lycLeftMenuViewController *leftMenu;
@end
