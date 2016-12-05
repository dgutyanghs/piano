//
//  NSString+size.m
//  SmartBra
//
//  Created by AlexYang on 16/10/26.
//
//

#import "NSString+size.h"

@implementation NSString (size)
//- (CGFloat)preferredHeightForMessageString:(NSString*)message {
//    
//    if (!message || message.length == 0) {
//        return ceilf(0.f);
//    }
//    
//    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraphStyle.alignment = NSTextAlignmentLeft;
//    
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    
//    CGFloat messageHeight = [message boundingRectWithSize:CGSizeMake(0, CGFLOAT_MAX)
//                                                  options:NSStringDrawingUsesLineFragmentOrigin
//                                               attributes:@{NSParagraphStyleAttributeName : paragraphStyle,
//                                                            NSFontAttributeName : [UIFont systemFontOfSize:15.f]}
//                                                  context:nil].size.height;
//    
//    return ceilf(messageHeight);
//    
//}
//

- (CGSize)boundingRectWithSize:(CGSize)size withFont:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGSize retSize = [self boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
@end
