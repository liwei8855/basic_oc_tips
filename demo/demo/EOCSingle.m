//
//  EOCSingle.m
//  demo
//
//  Created by lee on 17/3/24.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "EOCSingle.h"

@implementation EOCSingle

//只需执行一次的线程安全代码
+ (instancetype)sharedInstance {

    static EOCSingle *sharedInstance = nil;//把变量定义在static作用域中保证编译器每次执行方法都复用这个变量不会创建新变量
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EOCSingle alloc] init];
    });
    return sharedInstance;
    
}

@end
