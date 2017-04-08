//
//  PriceDetailViewController.m
//  UsedPiano
//
//  Created by  BlueYang on 2017/4/8.
//  Copyright © 2017年 Blueyang. All rights reserved.
//

#import "PriceDetailViewController.h"
#import <WebKit/WebKit.h>

@interface PriceDetailViewController ()
@property (nonatomic , weak) WKWebView *webView;
@end

@implementation PriceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"报价统计";
    
    [self initialUIResource];
}


- (void)initialUIResource {
    WKWebView *webView = [WKWebView newAutoLayoutView];
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
//    UIWebView *web = [[UIWebView alloc] init];
//    web.scalesPageToFit = YES;
    
    [self.view addSubview:webView];
    self.webView = webView;
    
    [webView autoPinEdgesToSuperviewEdges];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
