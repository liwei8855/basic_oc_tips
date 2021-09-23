//
//  Student.m
//  demo
//
//  Created by lee on 2018/6/8.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "Student.h"
#import <objc/runtime.h>

@implementation Student

- (void)eatWith:(NSString *)food {
    NSLog(@"子类方法%@",food);
    
}

//+ (BOOL)resolveClassMethod:(SEL)sel {
//
//}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    /*
     1. cls 类
     2. sel 方法编号
     3. imp 函数指针
     4. 返回类型
     */
    class_addMethod(self, sel, (IMP)smile, "v@:@");
    return [super resolveInstanceMethod:sel];
}
//函数名就是指向函数地址的指针
/*
 OC方法调用，会传默认两个隐式参数给imp
 objc_msgSend(self, _cmd)
 id self 方法调用者
 SEL _cmd 方法编号
 */
//如果有参数就要把参数补全
void smile(id self, SEL _cmd, NSString *objc) {
    NSLog(@"smile  %@",objc);
}


@end
