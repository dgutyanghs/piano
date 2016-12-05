

#import "HLMainNavigationController.h"
#import "UIColor+Help.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"

@interface HLMainNavigationController ()

@end

@implementation HLMainNavigationController


+ (void)initialize
{
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    item.tintColor = [UIColor whiteColor];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    
    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
}

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
        UIBarButtonItem *leftBarItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"back" highImage:@"back"];
        viewController.navigationItem.leftBarButtonItem = leftBarItem;
//        viewController.navigationItem.leftBarButtonItem.customView.width = 10.0;
//        viewController.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 44, 44);
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
    [self popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.设置导航栏默认样式
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"home_bg"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationBar setBarTintColor:[UIColor colorWithHex:0x413661]];
    self.navigationBar.barStyle = UIBarStyleBlack;
    //    [self.navigationBar setBarTintColor:[UIColor blackColorHL2]];
    //    self.navigationBar.translucent = NO;
    //    self.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    //2.设置标题默认样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:20.0];
    [self.navigationBar setTitleTextAttributes:textAttrs];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)dealloc {
//    [super dealloc];
    NSLog(@"HLMainNavigationController dealloc");
}

@end
