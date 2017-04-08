//
//  PriceTableViewController.m
//  Pods
//
//  Created by  BlueYang on 2017/4/8.
//
//


#import "PriceTableViewController.h"
#import "TFHpple.h"
#import "PopPiano.h"
#import "PriceDetailViewController.h"
#import "SURefreshHeader.h"


#define PRICE_URLSTR @"http://www.popiano.org/price/name/"

@interface PriceTableViewController ()
@property (nonatomic , strong) NSMutableArray <PopPiano *> *popPianos;
@end

@implementation PriceTableViewController

- (NSMutableArray *)popPianos {
    if (_popPianos == nil) {
        _popPianos = [NSMutableArray arrayWithCapacity:1];
    }
    
    return _popPianos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"市场热门型号";
//    self.tabBarItem.title = @"行情";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadPriceData];
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderWithHandle:^{
        [weakSelf loadPriceData];
    }];
    
}


- (void)loadPriceData {
    
    NSURL *priceUrl = [NSURL URLWithString:PRICE_URLSTR];
    
    NSData *htmlData = [NSData dataWithContentsOfURL:priceUrl];
    
    // 2
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:htmlData];
    
    // 3
    NSString *popXpathQueryString = @"//div[@id='content']/a";
    NSArray *popNodes = [htmlParser searchWithXPathQuery:popXpathQueryString];
    
    // 4
    NSMutableArray *pops = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in popNodes) {
        // 5
        PopPiano *item = [[PopPiano alloc] init];
        [pops addObject:item];
        
        // 6
        item.title = [[element firstChild] content];
        
        // 7
        item.url = [element objectForKey:@"href"];
    }
    
    // 8
    _popPianos = pops;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.popPianos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    static NSString *cellID = @"pricecellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    PopPiano *item = self.popPianos[indexPath.row];
    
    cell.textLabel.text = item.title;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PriceDetailViewController *detailVC = [[PriceDetailViewController alloc] init];
    
    PopPiano *item = self.popPianos[indexPath.row];
    detailVC.urlStr = item.url;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
