//
//  AYPlayViewController.m
//  UsedPiano
//
//  Created by AlexYang on 17/3/20.
//  Copyright © 2017年 Blueyang. All rights reserved.
//

#import "AYPlayViewController.h"
#import <WebKit/WebKit.h>
#import "AYWebView.h"

@interface AYPlayViewController () <WKNavigationDelegate>
@property (nonatomic, weak) AYWebView *webView;
@end

@implementation AYPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialWebView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialWebView {
    AYWebView *webView = [[AYWebView alloc] initWithFrame:self.view.frame];
    self.webView = webView;
    _webView.navigationDelegate = self;
    NSURL *url = [NSURL URLWithString:@"http://120.25.207.78:8080/vod/nhk_piano.m3u8"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10];
    
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [self.webView addGestureRecognizer:longTap];
}


- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (BOOL)shouldAutorotate {
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscape;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationLandscapeLeft;
//}



@end
