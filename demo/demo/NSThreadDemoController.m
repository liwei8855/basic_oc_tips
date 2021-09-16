//
//  NSThreadDemoController.m
//  demo
//
//  Created by lee on 2018/3/23.
//  Copyright © 2018年 lee. All rights reserved.
/*
  多线程：
 1. 不要相信一次运行的结果
 2. 不要去做不同线程的比较，线程内部方法都是各自独立执行的
 */

#import "NSThreadDemoController.h"

@interface NSThreadDemoController ()
@property (assign, nonatomic) int saleCount;
@end

@implementation NSThreadDemoController

- (void)loadView {
    [super loadView];
    NSLog(@"load view");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"will appear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.saleCount = 20;
    [self mutexLock];
}

#pragma mark - 互斥锁
- (void)mutexLock {
    
    NSThread *t1 = [[NSThread alloc] initWithTarget:self selector:@selector(sale) object:nil];
    t1.name = @"sale A";
    [t1 start];
    
    NSThread *t2 = [[NSThread alloc] initWithTarget:self selector:@selector(sale) object:nil];
    t2.name = @"sale B";
    [t2 start];
}
/*
 ios开发使用锁机会少
 互斥锁性能差，苹果不推荐，无代码提示
 */
- (void)sale {
    while (YES) {
        //互斥锁保证锁定范围代码，同一时间，只有一条线程能够执行
        //锁范围内一个线程执行时，其他线程在锁范围外等待
        //尽量减少锁定代码范围
        //锁定范围越大，效率越差
        @synchronized(self) {
        //self处要是全局唯一且所有线程都能访问到的，不能是变化的，self能保证唯一，用self比较好
            if (self.saleCount>0) {
                self.saleCount--;
                NSLog(@"%@--%d",[NSThread currentThread], self.saleCount);
            } else {
                NSLog(@"sale out%@",[NSThread currentThread]);
                break;
            }
        }
    }
}

#pragma mark - 创建、执行线程、线程属性

- (void)demo1 {
    //新建线程可以控制执行时间
    NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(longOperation:) object:@"NSThread"];
    //线程名称
    t.name = @"app thread";
    //线程优先级 0 ~ 1.0 , 默认0.5， 不建议修改线程优先级
    //⚠️注意：优先级高CPU会优先调度，但不是优先级低的就不调度，并不是优先级高的运行完再运行优先级低的，是穿插调用的
    t.threadPriority = 0;
    //栈区大小512k 可以修改
    [NSThread currentThread].stackSize = 1024 * 1024; //1M
    //线程被添加到可调度线程池，就绪状态等待cpu调度执行（并不是start就马上执行）
    [t start];
}

- (void)demo2 {
    //新建线程直接添加到调度线程池
    [NSThread detachNewThreadSelector:@selector(longOperation:) toTarget:self withObject:@"detach"];
}

- (void)demo3 {
    //NSObject的一个分类方法
    //新建线程直接添加到调度线程池
    [self performSelectorInBackground:@selector(longOperation:) withObject:@"in back"];
}

- (void)longOperation:(id)obj {
    for (int i=0; i<10; i++) {
        NSLog(@"%@--%d--%@--线程名%zd--栈区大小%tuK",[NSThread currentThread], i, obj,[NSThread currentThread].name,[NSThread currentThread].stackSize/1024);
    }
}

#pragma mark - 线程阻塞、死亡状态

- (void)demo4 {
    NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(blockOperation:) object:nil];
    [t start];
}

- (void)blockOperation:(id)obj {
    NSLog(@"sleep");
    //sleep 1s
    [NSThread sleepForTimeInterval:1.0];
    for (int i=0; i<10; i++) {
        NSLog(@"%@--%d--%@",[NSThread currentThread], i, obj);
        if (i==5) {
            NSLog(@"sleep again");
            //sleep到date的时间
            [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
        }
        if (i==8) {
            //退出当前线程，一旦退出后续代码都不会执行
            //注意：直接执行exit退出后不会清理资源，注意release
            //⚠️不能在主线程exit，程序就挂了
            [NSThread exit];
        }
    }
    NSLog(@"线程死亡后我不会输出");
}

#pragma mark - 线程优先级
/*
 线程优先级 0 ~ 1.0 , 默认0.5， 不建议修改线程优先级
 ⚠️注意：优先级高CPU会优先调度，但不是优先级低的就不调度，并不是优先级高的运行完再运行优先级低的
        所以运行结果并不是b全部执行完才有a执行， ab交替出现
 */
- (void)demo5 {
    NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(longOperation:) object:@"NSThread"];
    t.name = @"aaaaa";
    t.threadPriority = 0;
    [t start];
    
    NSThread *t1 = [[NSThread alloc] initWithTarget:self selector:@selector(longOperation:) object:@"NSThread"];
    t1.name = @"bbbb";
    t1.threadPriority = 1.0;
    [t1 start];
}


@end
