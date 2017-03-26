//
//  AboutmeViewController.m
//  UsedPiano
//
//  Created by  BlueYang on 2017/3/26.
//  Copyright © 2017年 Blueyang. All rights reserved.
//

#import "AboutmeViewController.h"

@interface AboutmeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation AboutmeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于";
    [self initialResource];
    
}

- (void)initialResource {
    self.descTextView.editable = NO;
    NSString *desc = @"    中古钢琴，到现在仍有很好的使用价值，特别是90年代左右的日本钢琴，选材严格，品质优良。深受广大专业人士喜爱.\n本App 收集了大量的古代，近代的钢琴数据，包括型号，颜色，生产年份，发行价格等等。供大家参考.";
    self.descTextView.text = desc;
    [self.logoImageView setImage:[UIImage imageNamed:@"pianoPNG60"]];
    self.logoImageView.layer.cornerRadius = 5;
    self.logoImageView.layer.masksToBounds = YES;
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
