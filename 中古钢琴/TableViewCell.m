//
//  TableViewCell.m
//  Used Piano
//
//  Created by Blueyang on 15-2-3.
//  Copyright (c) 2015年 Blueyang. All rights reserved.
//

#import "TableViewCell.h"
#import "JsonModel.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
   static NSString *ID = @"JsonModel";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setJs:(JsonModel *)js
{
    _js = js;
    self.name.text = js.name;
    self.address.text = [NSString stringWithFormat:@"地址: %@", js.address];
    self.telephone.text = [NSString stringWithFormat:@"电话: %@", js.telephone?js.telephone:@"无相关电话"];
}

@end
