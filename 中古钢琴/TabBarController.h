//
//  TabBarController.h
//  Microto
//
//  Created by Blueyang on 14-12-4.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface TabBarController : UITabBarController< UITabBarDelegate >

@property (nonatomic, strong) MapViewController *mapViewController;
@end
