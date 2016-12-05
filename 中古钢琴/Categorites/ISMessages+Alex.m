//
//  ISMessages+Alex.m
//  SmartBra
//
//  Created by AlexYang on 16/11/2.
//
//

#import "ISMessages+Alex.h"

@implementation ISMessages (Alex)

+(void)showNetworkResultMsg:(NSString *)msg Status:(ISAlertType)status {
    [ISMessages showCardAlertWithTitle:@"网络传输"
                               message:msg
                             iconImage:nil
                              duration:3.f
                           hideOnSwipe:YES
                             hideOnTap:YES
                             alertType:status
                             alertPosition:0];
}

+(void)showNetworkResultMsg:(NSString *)msg Status:(ISAlertType)status displayLastSeconds:(double)seconds {
    [ISMessages showCardAlertWithTitle:@"网络传输"
                               message:msg
                             iconImage:nil
                              duration:seconds
                           hideOnSwipe:YES
                             hideOnTap:YES
                             alertType:status
                            alertPosition:0];
}

+(void)showResultMsg:(NSString *)msg title:(NSString *)title Status:(ISAlertType)status {
    [ISMessages showCardAlertWithTitle:title
                               message:msg
                             iconImage:nil
                              duration:3.f
                           hideOnSwipe:YES
                             hideOnTap:YES
                             alertType:status
                             alertPosition:0];
}


+(void)showErrorMsg:(NSString *)msg title:(NSString *)title {
    [ISMessages showCardAlertWithTitle:title
                               message:msg
                             iconImage:nil
                              duration:3.f
                           hideOnSwipe:YES
                             hideOnTap:YES
                             alertType:ISAlertTypeError
                            alertPosition:0];
}

+(void)showSuccessMsg:(NSString *)msg title:(NSString *)title {
    [ISMessages showCardAlertWithTitle:title
                               message:msg
                             iconImage:nil
                              duration:3.f
                           hideOnSwipe:YES
                             hideOnTap:YES
                             alertType:ISAlertTypeSuccess
                            alertPosition:0];
}
@end
