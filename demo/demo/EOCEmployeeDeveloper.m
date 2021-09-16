//
//  EOCEmployeeDeveloper.m
//  demo
//
//  Created by lw on 17/2/25.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "EOCEmployeeDeveloper.h"

@implementation EOCEmployeeDeveloper

- (void)doADaysWork {
    [self writeCode];
}

- (void)writeCode {
    NSLog(@"write code");
}

//关于类型问题
- (BOOL)classTest {

    EOCEmployeeDeveloper *developer = [EOCEmployeeDeveloper new];
    return [developer isMemberOfClass:[EOCEmployee class]]; //NO
    //EOCEmployeeDeveloper是EOCEmployee子类不是EOCEmployee
}

@end
