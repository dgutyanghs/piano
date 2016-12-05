//
//  UINavigationBar+BackgroundColor.m
//  SmartBra
//
//  Created by Lynn on 2016/10/28.
//
//

#import  "UINavigationBar+BackgroundColor.h"
#include <objc/runtime.h>

@implementation UINavigationBar (BackgroundColor)
static char overlayKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        // insert an overlay into the view hierarchy
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height + 20)];
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.overlay.userInteractionEnabled = NO;
        double version = [[UIDevice currentDevice] systemVersion].doubleValue;
        if (version >= 10.0) {
            [self insertSubview:self.overlay atIndex:-1];
        }else {
            [self insertSubview:self.overlay atIndex:0];
        }
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (void) lt_removeOverLay
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}
@end
