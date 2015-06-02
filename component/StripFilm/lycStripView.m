//
//  lycStripView.m
//  blogapp
//
//  Created by aotuman on 13-11-6.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import "lycStripView.h"
#import "lycStripModel.h"

@implementation lycStripView

- (id)initWithFrame:(CGRect)frame andArrStripModels:(NSArray *)newModels;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor blackColor];
        
        //添加图片
        _backgroupImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_backgroupImage setContentMode:UIViewContentModeScaleToFill];
        [_backgroupImage setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
       // _backgroupImage.image=[UIImage imageNamed:@"image1.jpg"];
      
        [self addSubview:_backgroupImage];
        
        _scrollView=[[UIScrollView alloc] initWithFrame:frame];
        _scrollView.backgroundColor=[UIColor clearColor];
        _scrollView.pagingEnabled=YES;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.delegate=self;
        [self addSubview:_scrollView];
        
        _pageControl=[[UIPageControl alloc] init];
        _pageControl.numberOfPages=newModels.count;
        [_pageControl sizeToFit];
        [_pageControl setCenter:CGPointMake(frame.size.width/2.0, frame.size.height-20)];
        [_pageControl addTarget:self action:@selector(turnImg:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
        
        _currentNum=-1;
        _arrStripModels=newModels;
        //初始化滚动视图的总 宽 高
        _scrollView.contentSize=CGSizeMake(_arrStripModels.count*frame.size.width, frame.size.height);
        //定时器
        _timer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(switchC) userInfo:nil repeats:YES];
        
        [self initImage];
       
    }
    return self;
}

#pragma mark 跳转到指定的视图
-(void)turnImg:(id)sender{
    [_timer invalidate];
    UIPageControl *p=(UIPageControl *)sender;
    NSLog(@"%i",p.currentPage);
    [_scrollView setContentOffset:CGPointMake((p.currentPage*_scrollView.frame.size.width), 0) animated:YES];
    
}
#pragma mark 定时切换图片
-(void)switchC{
    
    [_scrollView setContentOffset:CGPointMake((_currentNum+1==_arrStripModels.count?0:_currentNum+1)*self.frame.size.width, 0) animated:YES];
}

-(void)initImage{
    //计算当前视图使第几
    NSInteger nownumer=MAX(0, MIN(_arrStripModels.count, _scrollView.contentOffset.x/self.frame.size.width));
    if (nownumer!=_currentNum) {
        _currentNum=nownumer;
        
        _backgroupImage.image=[(lycStripModel *)[_arrStripModels objectAtIndex:_currentNum] img];
    }
    float offset=_scrollView.contentOffset.x-(_currentNum*self.frame.size.width);
    if (offset<0) {
         offset = self.frame.size.width - MIN(-offset, self.frame.size.width);
        _pageControl.currentPage=0;
        _backgroupImage.alpha=(offset/self.frame.size.width);
        
    }
    else if (offset!=0) {
        if (nownumer==_arrStripModels.count-1) {
            _pageControl.currentPage=_arrStripModels.count-1;
            _backgroupImage.alpha=1.0-(offset/self.frame.size.width);
        }else{
        _pageControl.currentPage = (offset > self.frame.size.width/2) ? _currentNum+1 : _currentNum;
        _backgroupImage.alpha=1.0-(offset/self.frame.size.width);
        }
    } else {
            _pageControl.currentPage = _currentNum;
            _backgroupImage.alpha=1;
    }
    
}
#pragma mark 滚动视图
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self initImage];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_timer invalidate];
    [self initImage];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
