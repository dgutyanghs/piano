//
//  BaiduViewController.h
//  Used Piano
//
//  Created by Blueyang on 15-1-28.
//  Copyright (c) 2015年 Blueyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapPoint;
@protocol RecentViewControllerDelegate <NSObject>
@optional
-(void)recentViewCellDidSelect:(MapPoint *)point;

@end

@interface BaiduViewController : UIViewController
@property (assign, nonatomic) id<RecentViewControllerDelegate> cellDelegate;
@end
