//
//  Singleton.m
//  demo
//
//  Created by lee on 2018/4/2.
//  Copyright © 2018年 lee. All rights reserved.
/*
    内存中只有唯一副本
    block中的代码只执行一次，且是同步执行，保证后续使用block中的结果
    dispatch_once_t 线程安全的
    onceTocken = 0 时执行block，不等于0不执行
 */

/*
    如果想除调用instance获取单例外，还可以自己创建该类实例
    注意不能重写allocWithZone(能保证无论怎么实例化对象，内存中只有唯一副本)
 */

#import "Singleton.h"

@implementation Singleton

+ (instancetype)instance {
//    static Singleton *instance;
    static dispatch_once_t onceTocken;
    NSLog(@"long - %ld",onceTocken);
    
    dispatch_once(&onceTocken, ^{
//        instance = [[self alloc] init];
        NSLog(@"只执行一次%@",[NSThread currentThread]);
    });
    
    NSLog(@"come here");
    return nil;//instance;
}

+ (void)test {
    [Singleton instance];
}

//互斥锁实现单例
+ (instancetype)syncInstance {
    static id instance;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

@end
