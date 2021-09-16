//
//  UIView+ViewController.m
//  demo
//
//  Created by lee on 2017/12/21.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

//获得当前view的controller
- (UIViewController *)viewController {
    UIResponder *nextResponder = self;
    while (nextResponder) {
        nextResponder = nextResponder.nextResponder;
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
//返回第一响应者
- (UIResponder *)findFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *view in self.subviews) {
        id responder = [view findFirstResponder];
        if (responder) {
            return responder;
        }
    }
    return nil;
}

/*
 * 打印当前UIResponder的所有nextResponder
 */
- (void)responderChain:(UIResponder *)responder {
    NSLog(@"----------The Responder Chain--------------");
    NSMutableString *spaces = [NSMutableString stringWithCapacity:4];
    while (responder) {
        NSLog(@"%@%@",spaces,self.class);
        responder = responder.nextResponder;
        [spaces appendString:@"----"];
    }
}

@end
