//
//  SearchViewController.h
//  blueZbar
//
//  Created by Blueyang on 14-5-19.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class piano ;

@interface SearchViewController : UIViewController<UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) piano *pianoDetail;
@property (assign ,nonatomic) NSInteger btnNo;
- (IBAction)goBack:(UIButton *)sender;
@end
