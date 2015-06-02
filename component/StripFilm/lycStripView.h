//
//  lycStripView.h
//  blogapp
//
//  Created by aotuman on 13-11-6.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lycStripView : UIView <UIScrollViewDelegate>
//滚动视图
@property (strong,nonatomic) UIScrollView *scrollView;
//翻页
@property (strong,nonatomic) UIPageControl *pageControl;
//图片
@property (strong,nonatomic) UIImageView *backgroupImage;
//数据对象数组
@property (strong,nonatomic) NSArray *arrStripModels;
//当前位置
@property (assign,nonatomic) NSInteger currentNum;
//延迟设置
@property (strong,nonatomic) NSTimer *timer;

- (id)initWithFrame:(CGRect)frame andArrStripModels:(NSArray *)newModels;
@end
