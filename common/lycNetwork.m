//
//  lycNetwork.m
//  blogapp
//
//  Created by aotuman on 13-11-12.
//  Copyright (c) 2013年 aotuman  http://www.apoyl.com. All rights reserved.
//

#import "lycNetwork.h"
#import "Reachability.h"


@implementation lycNetwork

static id lycMyNetWork;
+(id)defaultCenter{
    @synchronized(self){
        if (nil==lycMyNetWork) {
             lycMyNetWork=[[self alloc] init];
        }
       
    }
    return lycMyNetWork;
}

#pragma mark 启动通知中心 kv
-(void) runNotice{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _isReach=YES;
   
    //使用3G/GPRS网络
    _internetReachability=[Reachability reachabilityForInternetConnection];
    [_internetReachability startNotifier];
    [self updateInterfaceWithReachability:_internetReachability];
    //使用WiFi网络
    _wifiReachability=[Reachability reachabilityForLocalWiFi];
    [_wifiReachability startNotifier];
    [self updateInterfaceWithReachability:_wifiReachability];
    //特定网络
    _hostReachability=[Reachability reachabilityWithHostName:_hostname];
    [_internetReachability startNotifier];
    [self updateInterfaceWithReachability:_hostReachability];
}

- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
   
}

- (void) updateInterfaceWithReachability:(Reachability *)reachability
{
    
    if (reachability==_hostReachability) {
        [self connectReachability:reachability alertViewWithTitle:@"网络服务连接异常"];
    }
    if (reachability==_wifiReachability) {
        [self connectReachability:reachability alertViewWithTitle:@"wifi网络连接异常"];
    }
    
    if (reachability==_internetReachability) {
        [self connectReachability:reachability alertViewWithTitle:@"3G/GPRS网络连接异常"];
    }

}

#pragma mark 提示网络状态
- (void)connectReachability:(Reachability *)reachability alertViewWithTitle:(NSString *)title
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    //BOOL connectionRequired = [reachability connectionRequired];
   // NSLog(@"wang:%d",netStatus);
    switch (netStatus)
    {
        case NotReachable:        {
            if (_numReach==0) {
                _delegealert = [[UIAlertView alloc] initWithTitle:title message:@"暂无法访问" delegate:self cancelButtonTitle:@"离线观看" otherButtonTitles:@"离开",nil];
                //_delegealert.frame=CGRectMake(0, 0, 200, 100);
                //自动关闭提示
              //  [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(alertLost:) userInfo:nil repeats:NO];
                [_delegealert show];
            }
           
            _isReach=NO;
            _numReach++;
           // NSLog(@"NOT :%@",title);
            break;
        }
            
        case ReachableViaWWAN:        {
            _isReach=YES;
           // NSLog(@"WWAN");
            break;
        }
        case ReachableViaWiFi:        {
           //  NSLog(@"WIFI");
            _isReach=YES;
            break;
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //离线观看
            break;
        }
        case 1:
            //退出应用
            sleep(1);
            exit(0);
            break;
    
       
    }
 
}

#pragma mark 弹出自动消失
-(void)alertLost:(NSTimer *)timer{
    [_delegealert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];

}
@end
