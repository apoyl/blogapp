//
//  lycNetwork.h
//  blogapp
//
//  Created by aotuman on 13-11-12.
//  Copyright (c) 2013年 aotuman  http://www.apoyl.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Reachability,lycCache;
@interface lycNetwork : NSObject <UIAlertViewDelegate>

//网络状态
@property (assign,nonatomic) BOOL   isReach;
@property (strong,nonatomic) Reachability *hostReachability;
@property (strong,nonatomic) Reachability *wifiReachability;
@property (strong,nonatomic) Reachability *internetReachability;
//链接次数
@property (assign,nonatomic) NSInteger numReach;
//UIAlertViewDelegate 代理对象
@property (strong,nonatomic) UIAlertView *delegealert;
@property (strong,nonatomic) NSString *hostname;


+(id)defaultCenter;
#pragma mark 启动通知中心 kv
-(void) runNotice;
@end
