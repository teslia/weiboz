//
//  WebViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-5-15.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
    UILabel *label;
}
@end

@implementation WebViewController

-(id)initWithURL:(NSString *)url{
    if(self = [super init]){
        if(url.length < 1){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请求的地址不合法！" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
            return nil;
        }
        _url = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    float os = WXHLOSVersion();
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor blackColor];
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"<< 返回" forState:UIControlStateNormal];
    if(os>=7.0f){
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(2, 20, 60, 25);
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"刷新 >>" forState:UIControlStateNormal];
    if(os>=7.0f){
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [button2 addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(ScreenWidth - 60, 20, 60, 25);
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth /2 - 100, 22, 200, 20)];
    label.text = @"Lo安全极速浏览器";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight)];
    self.web.delegate = self;
    self.web.scalesPageToFit = YES;
    [self.web loadRequest:request];
    [self.web reload];
    [self.view addSubview:self.web];
    [self.view addSubview:button];
    [self.view addSubview:button2];
    [self.view addSubview:label];
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)reload{
    [self.web reload];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    label.alpha = 0;
    [UIView commitAnimations];
    label.text = @"嘿咻..嘿咻...";
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    label.alpha = 1;
    [UIView commitAnimations];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    label.alpha = 0;
    [UIView commitAnimations];
    label.text = @"：) 加载完毕";
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    label.alpha = 1;
    [UIView commitAnimations];
    [self performSelector:@selector(resetLabel) withObject:nil afterDelay:3];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    label.alpha = 0;
    [UIView commitAnimations];
    label.text = @"：( 加载失败";
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    label.alpha = 1;
    [UIView commitAnimations];

    [self performSelector:@selector(resetLabel) withObject:nil afterDelay:3];
}
-(void)resetLabel{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    label.alpha = 0;
    [UIView commitAnimations];
    label.text = @"Lo安全极速浏览器";
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    label.alpha = 1;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
