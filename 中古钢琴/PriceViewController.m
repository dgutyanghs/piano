//
//  PriceViewController.m
//  Pods
//
//  Created by  BlueYang on 2017/4/8.
//
//


#import "PriceViewController.h"
#import "TFHpple.h"
#import "PopPiano.h"
#import "PriceDetailViewController.h"
#import "SURefreshHeader.h"


#define PRICE_URLSTR @"http://www.popiano.org/price/name/"

@interface PriceViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic , strong) NSMutableArray <PopPiano *> *popPianos;
@property (nonatomic , strong) NSArray <PopPiano *> *dataSourcePianos;
//@property (nonatomic, weak) UITableView *tableView;
@end

@implementation PriceViewController

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
    self.searchBar.placeholder = @"请输入品牌型号(如:珠江 118)";
    self.searchBar.delegate  = self;
    
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
    
    @autoreleasepool {
        for (TFHppleElement *element in popNodes) {
            // 5
            PopPiano *item = [[PopPiano alloc] init];
            [pops addObject:item];
            
            // 6
            item.title = [[element firstChild] content];
            
            // 7
            item.url = [element objectForKey:@"href"];
        }
    }
    // 8
    _popPianos = pops;
    
    NSString *priceQueryString = @"//div[@id='content']/text()";
    NSArray *priceNodes = [htmlParser searchWithXPathQuery:priceQueryString];
    NSMutableArray *newPriceArray = [NSMutableArray arrayWithCapacity:1];
    
    NSArray <NSString *> *resultArray = [NSArray array];
    
    @autoreleasepool {
        
        for (TFHppleElement *element in priceNodes) {
            NSString *title = [element  content];
            NSLog(@"price:%@", title);
            [newPriceArray addObject:title];
        }
        
        NSString *matchStr = @"均价";
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",matchStr];
        resultArray = [newPriceArray filteredArrayUsingPredicate:bPredicate];
    }
    
    for (int i = 0; i < self.popPianos.count; i++) {
        PopPiano *item = self.popPianos[i];
        item.price = resultArray[i];
    }
    
    self.dataSourcePianos = self.popPianos;
    
    
    [self.tableView reloadData];
    [self.tableView.header endRefreshing];
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
    return self.dataSourcePianos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    static NSString *cellID = @"pricecellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    PopPiano *item = self.dataSourcePianos[indexPath.row];
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.price;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PriceDetailViewController *detailVC = [[PriceDetailViewController alloc] init];
    
    PopPiano *item = self.popPianos[indexPath.row];
    detailVC.urlStr = item.url;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}



#pragma mark - UISearchBar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    [self.popPianos removeAllObjects];
    if ([searchText isEqualToString:@""]) {
        self.dataSourcePianos = self.popPianos;
    }else {
        NSString *matchStr = searchText;
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS %@",matchStr];
        NSArray *resultArray = nil;
        resultArray = [self.popPianos filteredArrayUsingPredicate:bPredicate];
        self.dataSourcePianos = resultArray;
    }
    [self.tableView reloadData];

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

@end
