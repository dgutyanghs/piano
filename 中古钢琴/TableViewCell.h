//
//  TableViewCell.h
//  Used Piano
//
//  Created by Blueyang on 15-2-3.
//  Copyright (c) 2015年 Blueyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JsonModel;
@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *telephone;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) JsonModel *js;
@end
