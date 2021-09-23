//
//  NSString+EOCMyAdditions.m
//  demo
//
//  Created by lee on 17/3/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NSString+EOCMyAdditions.h"
#import <objc/runtime.h>

@implementation NSString (EOCMyAdditions)

//互换两个已经写好的方法实现
//1.获得两个要交换的方法实现
//Method originalMethod = class_getInstanceMethod([NSString class], @selector(lowercaseString))
//Method swappedMethod = class_getInstanceMethod([NSString class], @selector(uppercaseString))
//2.交换方法
//void method_exchangImplementations(Method m1, Method m2)


//为既有的方法实现增添新功能
//调用lowercaseString时记录某些信息，编写新方法，实现新功能，并调用原有实现
- (NSString *)eoc_myLowercaseString {
    NSString *lowercase = [self eoc_myLowercaseString];
    //不会死循环，因为运行期 这个方法其实是lowercaseString
    //lowercaseString 是 eoc_myLowercaseString 并不是同一个方法，不会递归死循环
    NSLog(@"%@ => %@",self, lowercase);
    return lowercase;
}

@end
