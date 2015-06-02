//
//  lycFunc.h
//  blogapp
//
//  Created by aotuman on 13-11-12.
//  Copyright (c) 2013年  aotuman http://www.apoyl.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lycFunc : NSObject

@property (strong,nonatomic) UIViewController *uivc;
#pragma mark 导航左按钮
- (void)navLeftButton:(UIViewController *)sender withAction:(SEL)ac;
#pragma mark 导航右按钮
- (void)navRightButton:(UIViewController *)sender withAction:(SEL)ac;
@end
