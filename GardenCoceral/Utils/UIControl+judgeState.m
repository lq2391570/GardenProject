//
//  UIControl+judgeState.m
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/4.
//  Copyright © 2018年 tongna. All rights reserved.
//

#import "UIControl+judgeState.h"
#import <objc/message.h>
#import "GardenCoceral-Swift.h"
#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"


@implementation UIControl (judgeState)
+ (void)load
{
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(judge_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}
- (void)judge_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    NSLog(@"点击了btn222");
    UserClass *userClass = [[UserClass alloc] init];
    if (![userClass isMember]) {
//        [SVProgressHUD showInfoWithStatus:@"不是会员无法操作"];
//        return;
    }
    
    
    [self judge_sendAction:action to:target forEvent:event];
    
}
@end
