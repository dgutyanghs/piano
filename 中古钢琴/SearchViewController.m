//
//  SearchViewController.m
//  blueZbar
//
//  Created by Blueyang on 14-5-19.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
//

#import "SearchViewController.h"
#import "piano.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@end

@implementation SearchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.webView.delegate = self;
    [self _searchPiano:_pianoDetail];
    
    self.title = @"淘宝搜索结果";
    self.webView.backgroundColor = [UIColor grayColor];
    self.btnBack.layer.cornerRadius = 20;
    self.btnBack.layer.masksToBounds = YES;
}



-(void)_searchPiano:(piano *)pianoDetail
{
    NSString *taobao = nil;
    NSString *baidu = nil;
    if (_btnNo == 2) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            taobao = @"http://s.m.taobao.com/search.htm?q=";
        }else {

            taobao = @"http://s.m.taobao.com/search.htm?q=";
        }
//            NSString *net   = [taobao stringByAppendingString:pianoDetail.model];
            NSString *net = [taobao stringByAppendingFormat:@"%@+%@", pianoDetail.logo,pianoDetail.model];
//            NSLog(@"net =%@", net);

            net = [net stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url=[[NSURL alloc]initWithString:net];
            NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
            [_webView loadRequest:request];
    
    }else if(_btnNo == 1){
        
            //http://www.baidu.com/s?wd=abc
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            baidu = @"http://m.baidu.com/s?word=";
        }else {
            
             baidu = @"http://m.baidu.com/s?word=";
        }
            NSString *net = [baidu stringByAppendingFormat:@"%@+%@", pianoDetail.logo,pianoDetail.model];
        
//            NSString *net = [baidu stringByAppendingFormat:@"%@", pianoDetail.logo];
//            NSLog(@"net =%@", net);
            net = [net stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url=[[NSURL alloc]initWithString:net];
//            NSURL *weburl = [NSURL URLWithString:url];
            NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
            [_webView loadRequest:request];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UIWebView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
//    NSLog(@"shouldStartload");
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//        NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//            NSLog(@"webViewDidFinishLoad");
//
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"error %@", error );
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络不通" message:@"请确保wifi或3G网络打开" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

//-(BOOL)prefersStatusBarHidden
//{
//    return YES;
//}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (IBAction)goBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
