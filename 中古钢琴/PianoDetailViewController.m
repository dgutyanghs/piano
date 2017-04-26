//
//  PianoDetailViewController.m
//  日本二手钢琴大全
//
//  Created by Blueyang on 14-10-24.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
//

#import "PianoDetailViewController.h"
#import "piano.h"

@interface PianoDetailViewController ()
@property (nonatomic, strong) NSDictionary *pianoData;
@property (nonatomic, strong) NSArray *pianoKey;
@property (nonatomic, strong) NSArray *pianoKeyCN;
//@property (nonatomic, strong) NSDictionary * dic;

@property (weak, nonatomic) IBOutlet UIButton *btnTaoBao;
@property (weak, nonatomic) IBOutlet UIButton *btnBaidu;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;


- (IBAction)ShareOnClick:(UIButton *)sender;

@end

@implementation PianoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.hidden = NO;
    //disable "关于' button
    
    self.tableView.dataSource   = self;
    self.tableView.delegate     = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight    = 32.0;
    self.title = [self.pianoDetail model];
    
    [self _pianoDataInit:self.pianoDetail];
    
//    self.btnBaidu.tag   = 1;
    self.btnTaoBao.tag  = 2;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"background3.png"];
//    UIImage *backgroundImage = [UIImage imageNamed:@"girlPiano2.jpg"];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
//    self.view.alpha = 0.5;
//    self.tableView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:backgroundImage];
    
    self.btnTaoBao.layer.cornerRadius = 6;
    self.btnTaoBao.layer.masksToBounds = YES;
    self.btnBaidu.layer.cornerRadius = 6;
    self.btnBaidu.layer.masksToBounds = YES;
    self.btnShare.layer.cornerRadius = 6;
    self.btnShare.layer.masksToBounds = YES;

    self.btnBaidu.hidden = YES;
    self.btnTaoBao.hidden = YES;
    self.btnShare.hidden = YES;
}


-(void)_pianoDataInit:(piano *)pianoDetail
{

    NSString * path = [[NSBundle mainBundle]pathForResource:@"piano_detail" ofType:@"plist"];
    NSArray * array = [[NSArray alloc]initWithContentsOfFile:path];
    
//    NSLog(@"array %@", array);
    
    _pianoKey   = array[1];
    _pianoKeyCN = array[0];
}




#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.pianoKey count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID  = @"DetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }

    cell.textLabel.text = self.pianoKeyCN[indexPath.row];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor clearColor] ;
    }else {
        cell.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
        cell.textLabel.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
        cell.detailTextLabel.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
    }
    

    id obj = [self.pianoDetail valueForKey:self.pianoKey[indexPath.row]];
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"Verdana-Italic" size:15.0];
    cell.detailTextLabel.text = obj;
    cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor cyanColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.alpha = 0.4;
    return cell;
}

- (IBAction)inforBtnOnClicked:(UIBarButtonItem *)sender {
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"中古钢琴大全" message:@"感谢大家的支持，如有问题请联系:\ndgutyang@gmail.com" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];

}

- (IBAction)ShareOnClick:(UIButton *)sender {

//    UIImage * imageScreen = [self imageFromView:self.view];
//    NSString * content = [NSString stringWithFormat:@"来自App'中古钢琴'：品牌：%@  型号：%@\n", self.pianoDetail.logo, self.pianoDetail.model];
}


//获得屏幕图像
- (UIImage *)imageFromView: (UIView *) theView
{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


@end
