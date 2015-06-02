//
//  lycAppDelegate.m
//  blogapp
//
//  Created by aotuman on 13-10-21.
//  Copyright (c) 2013年 aotuman  http://www.apoyl.com. All rights reserved.
//

#import "LYCAppDelegate.h"
#import "lycIndexViewController.h"
#import "lycRightViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "lycLeftMenuViewController.h"
#import "lycSlideSwitchViewController.h"
#import "lycNetwork.h"
#import "Reachability.h"

#import "AFNetworkActivityIndicatorManager.h"

@implementation LYCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
   //显示网络状态
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 // [[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];
  
    //网络监听
    _lycnetwork=[lycNetwork defaultCenter];
    [_lycnetwork  setHostname:@"www.baidu.com"];
    [_lycnetwork runNotice];
    //休眠2秒
    [NSThread sleepForTimeInterval:2];
    
    //左右滑动
    lycRightViewController *right=[[lycRightViewController alloc] init];
   
    lycLeftMenuViewController *left=[[lycLeftMenuViewController alloc] init];
    lycSlideSwitchViewController *slide=left.slideSwitchVC;
    slide.leftMenu=left;
    
    UINavigationController *navSlideSwitchVC = [[UINavigationController alloc] initWithRootViewController:slide];
    
   // [navSlideSwitchVC setNavigationBarHidden:YES];
    left.commonNAV=navSlideSwitchVC;
   
    //显示下面的托盘
    //[left.commonNAV setToolbarHidden:NO];
    
    lycIndexViewController *m=[[lycIndexViewController alloc] initWithCenterViewController:navSlideSwitchVC leftDrawerViewController:left rightDrawerViewController:right];
    
    [m setMaximumLeftDrawerWidth:160.0f];
    [m setMaximumRightDrawerWidth:160.0f];
    [m setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [m setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [m setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState swingingDoorVisualStateBlock];
        block(drawerController, drawerSide, percentVisible);
    }];
    _indexViewController=m;
//    UINavigationController *nv=[[UINavigationController alloc] initWithRootViewController:_indexViewController];
    
//    [nv setNavigationBarHidden:YES animated:NO];
    self.window.rootViewController=_indexViewController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    
     
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   
   
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
