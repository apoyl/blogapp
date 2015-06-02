//
//  lycDetailViewController.m
//  blogapp
//
//  Created by aotuman on 13-10-31.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import "lycDetailViewController.h"
#import "lycNews.h"
#import "MBProgressHUD.h"
#import "UIViewController+MMDrawerController.h"
#import "LYCInputBar.h"
#import <Social/Social.h>


@implementation lycDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
           }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置左边栏目关闭
    [self.mm_drawerController setLeftDrawerViewController:nil];
    
    self.webview.delegate=self;
    //返回 刷新
    UIBarButtonItem *left=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backSlideSwitchView:)];
    self.navigationItem.leftBarButtonItem=left;
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];
    self.navigationItem.rightBarButtonItem=right;
    
    //toobar
    // 托盘
    UITextField *msg=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    msg.placeholder=@"评论";
    [msg setBorderStyle:UITextBorderStyleRoundedRect];
    UIBarButtonItem *one=[[UIBarButtonItem alloc] initWithCustomView:msg];
    //弹出评论
    LYCInputBar *inputBar=[[LYCInputBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY([UIScreen mainScreen].bounds)-44, 320, 64)];
    //inputBar.backgroundColor=[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
   // inputBar.backgroundColor=[UIColor whiteColor];
    inputBar.delegate = self;
    inputBar.clearInputWhenSend = YES;
    inputBar.resignFirstResponderWhenSend = YES;
    [self.view addSubview:inputBar];
   //分享
    UIBarButtonItem *share=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareNews:)];
    //上一篇 下一篇
    UIBarButtonItem *pre=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(preNews:)];
    UIBarButtonItem *next=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next"] style:UIBarButtonItemStylePlain target:self action:@selector(nextNews:)];
    
    
    NSArray *array=[NSArray arrayWithObjects:one,share,pre,next,nil];
    [self setToolbarItems:array animated:YES];
    [self.navigationController setToolbarHidden:NO];
    [self loadData:_lycnews.newid];
    }
#pragma mark 分享
- (void) shareNews:(id)selector{
    NSArray *activeItems;
    if (_lycnews.title!=nil) {
        activeItems=@[_lycnews.title];
    }
    UIActivityViewController *acitvityController=[[UIActivityViewController alloc] initWithActivityItems:activeItems applicationActivities:nil];
    [self presentViewController:acitvityController animated:YES completion:nil];
}
#pragma mark 上一篇
- (void) preNews:(id)selector{
    _lycnews.newid--;
    [self loadData:_lycnews.newid];
}

#pragma mark 下一篇
- (void) nextNews:(id)selector{
    _lycnews.newid++;
    [self loadData:_lycnews.newid];
}
- (void)loadData:(NSUInteger)newid{
    MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.mode=MBProgressHUDModeIndeterminate;
     //  hub.labelText=@"Loading...";
   // self.title=_lycnews.title;
    self.navigationItem.rightBarButtonItem.enabled=NO;
    [lycNews newsWithId:newid withBlock:^(NSArray *news, NSError *error) {
        if (news.count>0) {
            _lycnews =[news objectAtIndex:0];
            NSString *html=[NSString stringWithFormat:@"<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'><meta name='viewport' content='width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes'></head><body><div><h3>%@</h3></div><div></div><div>%@</div></body></html>",_lycnews.title,_lycnews.msgs];
            //自动缩放webview
            //_webview.scalesPageToFit=YES;
            [_webview loadHTMLString:html baseURL:nil];
           
           
        }
         self.navigationItem.rightBarButtonItem.enabled=YES;
        //关闭进度条
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
  
    

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url=[request.URL absoluteString];
   
    //判断是否为本地链接
    [self url:url andNavcontrol:self.parentViewController.navigationController];
   
    if ([url isEqualToString:@"about:blank"]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    //拦截网页图片  并修改图片大小
    [_webview stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=305;" 
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = myimg.height * (maxwidth/oldwidth);"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [_webview stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    //给网页增加css样式
    [_webview stringByEvaluatingJavaScriptFromString:
     @"var tagHead =document.documentElement.firstChild;"
     "var tagStyle = document.createElement(\"style\");"
     "tagStyle.setAttribute(\"type\", \"text/css\");"
     "tagStyle.appendChild(document.createTextNode(\"BODY{word-wrap: break-word;word-break: normal;}\"));"
     "var tagHeadAdd = tagHead.appendChild(tagStyle);"];
  
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

   
 
}


#pragma mark 判断是否为本地链接
-(BOOL)url:(NSString *)url andNavcontrol:(UINavigationController *)nav{
    NSString *str=@"scol.com.cn";
    NSRange rg=[url rangeOfString:str];
    if (rg.length<=0) {
       //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return NO;
    }else{
        
       return YES;
    }
   
}
#pragma mark 刷新
- (void)reload:(id)sender{
    [self loadData:_lycnews.newid];
    
}
#pragma mark 评论
- (void)inputBar:(LYCInputBar *)inputBar sendBtnPress:(UIButton *)sendBtn withInputString:(NSString *)str{
    NSLog(@"fasong");
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [((UIView*)obj) resignFirstResponder];
    }];
}
#pragma mark 返回
- (void)backSlideSwitchView:(id)sender{
  //
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void) viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:YES];
//    [self.view removeFromSuperview];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
  
}

@end
