//
//  GCDDemoController.m
//  demo
//
//  Created by lee on 2018/3/26.
//  Copyright © 2018年 lee. All rights reserved.
/*
    同步不开线程，异步开
    （异步）开线程数：串行队列开一条，并发队列n条，条数由GCD决定
 */

#import "GCDDemoController.h"
#import "Singleton.h"

@interface GCDDemoController ()

@end

@implementation GCDDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(a)];
    
}

- (void)a {
    NSLog(@"%@",[NSThread currentThread]);
 
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [Singleton test];
    [self semaphoreDemo];
}

#pragma mark - 信号量dispatch_semaphore_t，使用信号量来同步数据
/*
 当一个信号量被信号通知，其计数会被增加。当一个线程在一个信号量上等待时，
 线程会被阻塞（如果有必要的话），直至计数器大于零，然后线程会减少这个计数
*/
/*
 原理：
 1.创建信号量总数为0
 2.执行到wait时信号量-1小于0，所以阻塞（注意：此处分情况阻塞，如果去掉[mutableArray addObject:@(101)];只有一个输出就不阻塞，很智能，厉害！）
 3.wait阻塞，block执行，执行到signal，信号量+1，大于0，此时跳到wait后继续执行
 */
- (void)semaphoreDemo {
    //信号量传入参数0 表示没有资源，非0 表示有资源，可以理解为参数总量为0
    int p = 0;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);//创建信号参数必须大于或等于0
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    //模仿异步网络请求
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i=0; i<10; i++) {
            [mutableArray addObject:@(i)];
        }
        long runS = dispatch_semaphore_signal(semaphore);//发送信号，信号总量+1
        NSLog(@"%d****%ld******%@**%@",p,runS, mutableArray,[NSThread currentThread]);
    });
    //信号等待时 资源数-1 阻塞当前线程
    //当信号总量少于0的时候就会一直等待，否则就可以正常的执行，并让信号总量-1
    //DISPATCH_TIME_FOREVER 一直等待，也可以自定义设置等待时间dispatch_time_t类型：两种方法创建dispatch_time和dispatch_walltime
    long waitSig = dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//等待信号
    [mutableArray addObject:@(101)];
    NSLog(@"%d===%ld===%@==%@",p,waitSig, mutableArray,[NSThread currentThread]);
    NSLog(@"执行到这了");
}

#pragma mark - 调度组
- (void)demo12 {
    //group监听任务 queue调度任务
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, q, ^{
        NSLog(@"no1 %@",[NSThread currentThread]);
    });
    dispatch_group_async(group, q, ^{
        NSLog(@"no2 %@",[NSThread currentThread]);
    });
    dispatch_group_async(group, q, ^{
        NSLog(@"no3 %@",[NSThread currentThread]);
    });
    
    //监听所有任务完成后 由队列调度block中任务
//    dispatch_group_notify(group, q, ^{
//        NSLog(@"completion %@",[NSThread currentThread]);
//    });
    //也可以设置队列
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"completion %@",[NSThread currentThread]);
    });
    
    //群组等待 等到所有任务完成：阻塞式等待 群组任务不执行完后序代码不执行
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

#pragma mark - 全局队列
//本身是一个并发队列，方便用提供的
- (void)demo11 {
    //参数1:优先级（宏） DISPATCH_QUEUE_PRIORITY_DEFAULT(7.0) QOS_CLASS_UTILITY(8.0以上)
    //    2:保留参数：为0
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    
}

#pragma mark - 同步执行的作用
- (void)demo10 {
    dispatch_queue_t q = dispatch_queue_create("dependent", DISPATCH_QUEUE_CONCURRENT);
    //异步队列同步执行 可以让任务 依赖 某一个任务
    //登录后才能下载
    //同步任务不执行完，队列不会调度后边的任务
//    dispatch_sync(q, ^{ //此时由于是同步执行不会开启线程且同步任务不执行完不会继续执行，会马上执行login
//        NSLog(@"login %@",[NSThread currentThread]);
//    });
//    // login后，此时看到是异步任务才会开线程异步执行下边两个任务
//    dispatch_async(q, ^{
//        NSLog(@"download a %@",[NSThread currentThread]);
//    });
//
//    dispatch_async(q, ^{
//        NSLog(@"download b %@",[NSThread currentThread]);
//    });
    
/*登录耗时不能在主线程*/
//    dispatch_async(q, ^{
//        NSLog(@"login %@",[NSThread currentThread]);
//        dispatch_async(q, ^{
//            NSLog(@"download a %@",[NSThread currentThread]);
//        });
//
//        dispatch_async(q, ^{
//            NSLog(@"download b %@",[NSThread currentThread]);
//        });
//    });
    
    void (^task)(void) = ^ {
        dispatch_sync(q, ^{ //同步任务不执行完不会继续执行，会马上执行login
            NSLog(@"login %@",[NSThread currentThread]);
        });
        // login后会开线程异步执行下边两个任务
        dispatch_async(q, ^{
            NSLog(@"download a %@",[NSThread currentThread]);
        });
    
        dispatch_async(q, ^{
            NSLog(@"download b %@",[NSThread currentThread]);
        });
    };
    
    dispatch_async(q, task);
    
}

#pragma mark - 主队列

//主队列同步执行
//主队列与主线程互相等待：死锁
/*
 demo9方法也在主线程，
 dispatch_queue_t队列中任务要等当前队列(主队列)中当前任务(demo9方法)执行完毕后
 再执行加进去的打印任务，打印任务也要等demo9执行完毕 故互相等待了
 */
- (void)demo9 {
    NSLog(@"aaaaaa");
    dispatch_queue_t q = dispatch_get_main_queue();
    for (int i=0; i<10; i++) {
        dispatch_sync(q, ^{
            NSLog(@"%@--%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"sleep");
    [NSThread sleepForTimeInterval:1.0];
    NSLog(@"come here");
    
}

//主队列：负责在主线程调度任务，所有任务在主线程执行
//主队列（队列调度任务）与主线程（线程执行代码）不是一个概念
- (void)demo8 {
    //主队列：程序启动，主线程就已经存在，主队列也同时存在了，只需获取 不需要创建
    dispatch_queue_t q = dispatch_get_main_queue();
    for (int i=0; i<10; i++) {
        dispatch_async(q, ^{
            NSLog(@"%@--%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"sleep");
    [NSThread sleepForTimeInterval:1.0];
    NSLog(@"come here");
}

#pragma mark - 队列

//并发队列 同步执行
//不开线程 顺序执行
- (void)demo7 {
    dispatch_queue_t q = dispatch_queue_create("bingfa_queue", DISPATCH_QUEUE_CONCURRENT);
    for (int i=0; i<10; i++) {
        dispatch_sync(q, ^{
            NSLog(@"%@  %d",[NSThread currentThread], i);
        });
    }
    NSLog(@"come here");
}

//并发队列           异步执行
//同时调度多个任务     可以开启线程
//队列：本质上是‘先进先出’ 具体执行由CPU决定！
- (void)demo6 {
    dispatch_queue_t q = dispatch_queue_create("bingfa_queue", DISPATCH_QUEUE_CONCURRENT);
    for (int i=0; i<10; i++) {
        dispatch_async(q, ^{
            NSLog(@"%@  %d",[NSThread currentThread], i);
        });
    }
    NSLog(@"come here");
}

//串行队列 同步执行
- (void)demo5 {
    //串行队列任务是一个接一个完成的，同步执行不开新线程
    //只开一个线程，所以按顺序执行 come here等前边执行完再执行
    dispatch_queue_t q = dispatch_queue_create("chuanxing_queue", DISPATCH_QUEUE_SERIAL);
    for (int i=0; i<10; i++) {
        dispatch_sync(q, ^{
            NSLog(@"%@",[NSThread currentThread]);
        });
    }
    NSLog(@"come here%@",[NSThread currentThread]);//在最后执行
}

//串行队列 异步执行
- (void)demo4 {
    //串行队列任务是一个接一个完成的，开线程是因为是异步执行
    //由于开线程了log在子线程中执行，come here在主线程执行，所以顺序无法预计
    dispatch_queue_t q = dispatch_queue_create("chuanxing_queue", DISPATCH_QUEUE_SERIAL);
    for (int i=0; i<10; i++) {
        dispatch_async(q, ^{
            NSLog(@"%@",[NSThread currentThread]);
        });
    }
    NSLog(@"come here%@",[NSThread currentThread]);//不一定在什么时候执行
}

//线程间通讯
- (void)demo3 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"耗时操作%@",[NSThread currentThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"更新UI%@",[NSThread currentThread]);
        });
    });
}

#pragma mark - 异步执行 并发队列
// 异步：会开启线程
- (void)demo1 {
    //全局队列
    dispatch_queue_t q = dispatch_queue_create(0, 0);
    void (^block)(void) = ^(void) {
        NSLog(@"%@",[NSThread currentThread]);
    };
    dispatch_async(q, block);
}

#pragma mark - 同步执行 并发队列
//同步:不开启新线程，在当前线程执行
- (void)demo2 {
    dispatch_queue_t q = dispatch_queue_create(0, 0);
    void (^block)(void) = ^(void) {
        NSLog(@"%@",[NSThread currentThread]);
    };
    dispatch_sync(q, block);
}

@end
