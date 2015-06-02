//
//  lycAppDelegate.h
//  blogapp
//
//  Created by aotuman on 13-10-21.
//  Copyright (c) 2013年  aotuman http://www.apoyl.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class lycIndexViewController;

@class lycNetwork;
@interface LYCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) lycIndexViewController *indexViewController;
@property (strong,nonatomic) lycNetwork *lycnetwork;

@end
