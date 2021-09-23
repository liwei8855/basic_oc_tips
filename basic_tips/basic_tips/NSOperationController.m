//
//  NSOperationController.m
//  demo
//
//  Created by lee on 2018/4/3.
//  Copyright © 2018年 lee. All rights reserved.
/*
    NSOperation 抽象类
    核心概念：把操作添加到队列  （GCD将任务添加到队列）
 
    子类：NSBlockOperation
         NSInvocationOperation
 
    队列：NSOperationQueue
 
 */

#import "NSOperationController.h"

@interface NSOperationController ()
@property (strong, nonatomic) UIButton *btn;
@property (strong, nonatomic) UIButton *btn1;
@property (strong, nonatomic) NSOperationQueue *queue;
@end

@implementation NSOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 50)];
    [self.btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.btn setTitle:@"暂停／继续" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
    self.btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 200, 50)];
    [self.btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.btn1 setTitle:@"取消" forState:UIControlStateNormal];
    [self.btn1 addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn1];
    [self demo1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dependency];
}

#pragma mark - 依赖关系
//执行任务依赖关系-GCD使用同步任务（不开线程）
//NSOperation会开线程，但能够保证顺序，并发效果好
//注意依赖不要循环导致死循环
- (void)dependency {
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"登录%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"下载%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"更新UI%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"付费%@",[NSThread currentThread]);
    }];
    
    //先登录
    [op4 addDependency:op1];
    //下载之前付费
    [op2 addDependency:op4];
    //下载完更新UI
    [op3 addDependency:op2];
    
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    //NO:异步执行 YES同步执行
    [q addOperations:@[op1,op2,op3,op4] waitUntilFinished:YES];
    NSLog(@"completion%@",[NSThread currentThread]);
    
    //依赖关系可以跨队列（注意同步任务也可以 但注意死锁）
//    [[NSOperationQueue mainQueue] addOperation:op4];
}

#pragma mark - 取消所有操作
//cancelAllOperations方法通知队列取消其中的操作，在队列取消完成之前，操作技术不变
//包含正在执行中的操作+还没调度的操作
- (void)cancel {
    NSLog(@"count = %tu",self.queue.operationCount);
    //给队列发送取消操作的消息
    [self.queue cancelAllOperations];
    NSLog(@"count = %tu",self.queue.operationCount);
}

#pragma mark - 暂停/继续
//suspended 队列一旦被挂起就会暂停调度任务
///挂起的是队列，不会影响当前正在执行的操作：
///队列中的任务暂停执行，但已经分配线程执行的任务不会暂停
///所以点击暂停按钮可能还会有执行结果显示出来

- (void)stop {
    
    if (!self.queue.operationCount) {
        NSLog(@"没操作");
        return;
    }
    
    self.queue.suspended = !self.queue.suspended;
    //如果队列被挂起 operationcount包括没有执行完成的操作数（正在线程中执行的任务数）
    if (self.queue.isSuspended) {
        NSLog(@"stop-%tu",self.queue.operationCount);
    } else {
        //包含队列中所有要调度的操作
        NSLog(@"continue-%tu",self.queue.operationCount);
    }
}

#pragma mark - 最大并发数
- (void)demo6 {
    for (int i=0; i<10; i++) {
        [self.queue addOperationWithBlock:^{
            //不设置最大并发数时：1秒后全部打印，因为在不同的线程休眠1秒后多线程执行互不影响
            //设置最大并发数2后，两两打印，结合gcd底层线程池调度，线程复用理解
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"%d====%@",i,[NSThread currentThread]);
        }];
    }
}

#pragma mark - 线程通讯

- (void)demo5 {
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    [q addOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"更新UI%@",[NSThread currentThread]);
        }];
    }];
}

#pragma mark - NSBlockOperation

- (void)demo4 {
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    [q addOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
    }];
}

- (void)demo3 {
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
    }];
    [q addOperation:op];
}

#pragma mark - NSInvocationOperation

- (void)demo2 {
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    for (int i = 0; i<10; i++) {
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test:) object:@(i)];
        [q addOperation:op];
    }
}

- (void)demo1 {
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test:) object:@"operation"];
    
    //当前线程执行
    [op start];
    
    //将线程添加到队列 - 异步执行
//    NSOperationQueue *q = [[NSOperationQueue alloc] init];
//    [q addOperation:op];
}

- (void)test:(NSString *)n {
    NSLog(@"%@==%@",n,[NSThread currentThread]);
}

#pragma mark -

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 2;
    }
    return _queue;
}

@end
