//
//  LYCInputBar.h
//  blogapp
//
//  Created by aotuman on 13-12-30.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYCInputBar;
@protocol LYCInputBarDelegate <NSObject>

-(void)inputBar:(LYCInputBar*)inputBar sendBtnPress:(UIButton*)sendBtn withInputString:(NSString*)str;

@end
@interface LYCInputBar : UIView

//代理 用于传递btn事件
@property(assign,nonatomic)id<LYCInputBarDelegate> delegate;
//这两个可以自己付值
@property(strong,nonatomic)UITextField *textField;
@property(strong,nonatomic)UIButton *sendBtn;

//点击btn时候 清空textfield  默认NO
@property(assign,nonatomic)BOOL clearInputWhenSend;
//点击btn时候 隐藏键盘  默认NO
@property(assign,nonatomic)BOOL resignFirstResponderWhenSend;

//初始frame
@property(assign,nonatomic)CGRect originalFrame;

//隐藏键盘
-(BOOL)resignFirstResponder;
@end
