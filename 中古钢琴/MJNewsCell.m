//
//  MJNewsCell.m
//  08-无限滚动
//
//  Created by apple on 14-5-31.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJNewsCell.h"
#import "MJNews.h"

@interface MJNewsCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;


@end

@implementation MJNewsCell
- (void)setNews:(MJNews *)news
{
    _news = news;
    
    self.iconView.image = [UIImage imageNamed:news.icon];
//    self.titleLabel.text = news.title;
    self.titleLabel.text = [NSString stringWithFormat:@"  %@", news.title];

}



//-(void)awakeFromNib
//{
//    NSLog(@"W %.02f, H %.02f", self.bounds.size.width, self.bounds.size.height);
//    UIScreen *sc = [UIScreen mainScreen];
//    CGSize  rect = sc.bounds.size;
//    self.frame = CGRectMake(0, 0, rect.width, self.bounds.size.height);
//    NSLog(@"layout W %.02f, H %.02f", self.bounds.size.width, self.bounds.size.height);
//}


//-(void)layoutSubviews
//{
//    UIScreen *sc = [UIScreen mainScreen];
//    CGSize  rect = sc.bounds.size;
////    self.bounds = CGRectMake(0, 0, rect.width, IS_IPHONE?160:400);
////    NSLog(@"layout W %.02f, H %.02f", self.bounds.size.width, self.bounds.size.height);
//    
//    self.iconView.frame = self.bounds;
//}
@end
