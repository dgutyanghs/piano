//
//  NSString+size.h
//  SmartBra
//
//  Created by AlexYang on 16/10/26.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (size)
- (CGSize)boundingRectWithSize:(CGSize)size withFont:(UIFont *)font;
@end
