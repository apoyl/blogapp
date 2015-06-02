//
//  lycDetailViewController.h
//  blogapp
//
//  Created by aotuman on 13-10-31.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYCInputBar.h"
@class  lycNews;
@interface lycDetailViewController : UIViewController <UIWebViewDelegate,LYCInputBarDelegate>

@property (strong,nonatomic) lycNews *lycnews;

@property (strong,nonatomic) IBOutlet UIWebView *webview;

#pragma mark 载入数据
- (void)loadData:(NSUInteger)newid;
@end
