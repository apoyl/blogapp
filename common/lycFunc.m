//
//  lycFunc.m
//  blogapp
//
//  Created by aotuman on 13-11-12.
//  Copyright (c) 2013年 aotuman  http://www.apoyl.com. All rights reserved.
//

#import "lycFunc.h"
#import "lycIndexViewController.h"
#import "UIViewController+MMDrawerController.h"

@implementation lycFunc

- (void)navLeftButton:(UIViewController *)sender withAction:(SEL)ac{
    _uivc=sender;
    UIImage *img=[UIImage imageNamed:@"burger"];
    UIBarButtonItem *left=[[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleBordered target:sender action:ac];
    sender.navigationItem.leftBarButtonItem=left;
}

- (void)navRightButton:(UIViewController *)sender withAction:(SEL)ac{
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile"] style:UIBarButtonItemStyleBordered target:sender action:ac];
    
    sender.navigationItem.rightBarButtonItem=right;
}


@end
