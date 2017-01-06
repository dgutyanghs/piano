//
//  TabBarController.m
//  Microto
//
//  Created by Blueyang on 14-12-4.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
//

#import "TabBarController.h"
#import "MapPoint.h"

@interface TabBarController ()
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapViewController = self.viewControllers[1];


//    NSLog(@"addr %p", self.recentViewController);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark recentViewCell delegate
-(void)recentViewCellDidSelect:(MapPoint *)point;
{
    self.mapViewController.cmd = @1;
    self.mapViewController.location = point.location ;
    self.mapViewController.pointTitle = point.title;

    self.selectedIndex = 1;
}


//
//#pragma mark - UITabBarControllerDeleage
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    
//    if (self.selectedIndex == 1) {
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//    }else {
//        self.navigationItem.rightBarButtonItem.enabled = NO;
//    }
//}

@end
