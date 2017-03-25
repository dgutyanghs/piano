//
//  XLVideoItem.h
//  XLVideoPlayer
//
//  Created by Shelin on 16/3/24.
//  Copyright © 2016年 GreatGate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLVideoItem : NSObject

@property (nonatomic, strong) NSString *cover;

@property (nonatomic, strong) NSString *mp4_url;

@property (nonatomic, strong) NSString *title;

@property (nonatomic , assign) NSInteger  index;

@property (nonatomic , copy) NSString *desc;

@end
