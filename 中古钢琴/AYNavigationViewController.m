//
//  AYNavigationViewController.m
//  UsedPiano
//
//  Created by AlexYang on 17/3/8.
//  Copyright © 2017年 Blueyang. All rights reserved.
//

#import "AYNavigationViewController.h"
#import "UIBarButtonItem+Extension.h"

@interface AYNavigationViewController ()

@end

@implementation AYNavigationViewController

+ (void)initialize {
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName]   = [UIColor blackColor];
    textAttrs[NSFontAttributeName]              = [UIFont systemFontOfSize:13.0];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    item.tintColor = [UIColor whiteColor];
    
    
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    disableTextAttrs[NSFontAttributeName]            = [UIFont systemFontOfSize:13.0];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBarHidden = NO;
        
        UIBarButtonItem *leftBarItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"back" highImage:@"back"];
        viewController.navigationItem.leftBarButtonItem = leftBarItem;
    }
    
    [super  pushViewController:viewController animated:animated];
}


- (void)back {
    [self popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
