//
//  PianoDetailViewController.h
//  日本二手钢琴大全
//
//  Created by Blueyang on 14-10-24.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class piano;

@interface PianoDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) piano *pianoDetail;

- (IBAction)inforBtnOnClicked:(UIBarButtonItem *)sender;



@end
