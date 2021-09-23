//
//  QueueModel.m
//  demo
//
//  Created by lee on 17/3/17.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "QueueModel.h"

@interface QueueModel()

{
    NSString *_someString;
    dispatch_queue_t _syncQueue;
}

@end

@implementation QueueModel

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _syncQueue = dispatch_queue_create("syncQueue", NULL);
        _syncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

#pragma mark - 串行同步队列
//思路：把set与get都放在串行同步队列中，实现线程安全

- (NSString *)someString {

    __block NSString *localSomeString;
    dispatch_sync(_syncQueue, ^{
        localSomeString = _someString;
    });
    return localSomeString;
}

//- (void)setSomeString:(NSString *)someString {
//    dispatch_sync(_syncQueue, ^{
//        _someString = someString;
//    });
//}

#pragma mark - 引入栅栏块实现写入操作
//栅栏块：并发队列中栅栏块必须单独执行，不能与其他块并行
//注意：同步比异步要快：异步需要拷贝块，拷贝块需要的时间有可能比执行块慢
- (void)setSomeString:(NSString *)someString {
    dispatch_barrier_async(_syncQueue, ^{
        _someString = someString;
    });
}

#pragma mark - 延迟执行某方法
- (void)delay {
    //方法一：
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:5.0];
    
    //方法二：
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 5.0 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self delayMethod];
    });
}

#pragma mark - 把任务放在主线程执行
- (void)onMain {
    //方法一
    [self performSelectorOnMainThread:@selector(delayMethod) withObject:nil waitUntilDone:NO];
    //方法二
    dispatch_async(dispatch_get_main_queue(), ^{
        [self delayMethod];
    });
}

- (void)delayMethod {
    NSLog(@"延迟执行");
}

#pragma mark - dispatch group 任务分组

- (void)dispatch_group {

    //创建任务组
    dispatch_group_t dispatch_group_create();
    //把任务编组：两种方法
    //1、
//    dispatch_group_async(<#dispatch_group_t  _Nonnull group#>, <#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>);
    //2、指定任务所属的group：需成对出现，enter后没有leave，那么这组任务就永远执行不完
//    dispatch_group_enter(<#dispatch_group_t  _Nonnull group#>);//使分组任务数递增
//    dispatch_group_leave(<#dispatch_group_t  _Nonnull group#>);//递减
    
}

- (void)dispatch_wait {

    //等待group执行完毕:两种方法
    //1.等待当前线程执行完，会阻塞当前线程
    //    dispatch_group_wait(<#dispatch_group_t  _Nonnull group#>, <#dispatch_time_t timeout#>);
    /*params：
     要等待的group
     等待时间的timeout:函数在等待group执行完毕时，应该阻塞多久
     执行group时间<timeout retrun 0;否则返回非0
     DISPATCH_TIME_FOREVER一直等着group执行完，而不会超时
     */
    //2
    //    dispatch_group_notify(<#dispatch_group_t  _Nonnull group#>, <#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>);
    //group执行完块会在特定的线程执行：当前线程不阻塞，任务完成得到通知
    
    //eg:令数组中每个对象都执行某任务
    //1.阻塞当前线程
    NSDictionary *collection_a = [NSDictionary dictionary];
    dispatch_queue_t queue_a = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t dispatchGroup_a = dispatch_group_create();
    for (id object in collection_a) {
        dispatch_group_async(dispatchGroup_a, queue_a, ^{
            //[object performTask];
        });
    }
    
    dispatch_group_wait(dispatchGroup_a, DISPATCH_TIME_FOREVER);
    //continue processing after completing tasks
    
    //2.不阻塞当前线程
    //若当前线程不应该阻塞，可用notify来取代wait
    dispatch_queue_t notifyQueue_a = dispatch_get_main_queue();
    dispatch_group_notify(dispatchGroup_a, notifyQueue_a, ^{
        //continue after completing tesks
    });
    
    //可将任务派发到优先级高的线程上执行，同时把所有任务都归入一个group，执行完获得通知
    NSDictionary *lowPriorityObjects = [NSDictionary dictionary];
    NSDictionary *highPriorityObjects = [NSDictionary dictionary];
    
    dispatch_queue_t lowPriorityQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_queue_t highPriorityQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    for (id object in lowPriorityObjects) {
        dispatch_group_async(dispatchGroup, lowPriorityQueue, ^{
            //[object performTask];
        });
    }
    
    for (id object in highPriorityObjects) {
        dispatch_group_async(dispatchGroup, highPriorityQueue, ^{
            //[object performTask];
        });
    }
    
    dispatch_queue_t notifyQueue = dispatch_get_main_queue();
    dispatch_group_notify(dispatchGroup, notifyQueue, ^{
        //continue processing after completing tasks
    });

    //不使用group实现同样效果
    NSDictionary *collection = [NSDictionary dictionary];
    dispatch_queue_t queue = dispatch_queue_create("effective", NULL);
    for (id object in collection) {
        dispatch_async(queue, ^{
            //[object perfrom];
        });
    }
    
    dispatch_async(queue, ^{
       //continue processing after completing tasks.
    });
    
}

#pragma mark - gcd遍历函数
- (void)goThrough {

    dispatch_queue_t queue = dispatch_queue_create("com.through", NULL);
    dispatch_apply(10, queue, ^(size_t i) {
        //perform
    });
    //重复10次0-9执行
    
    //改写上边例子
    NSArray *array = [NSArray array];
    dispatch_queue_t queue_a = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(array.count, queue_a, ^(size_t i) {
        id object = array[i];
        //object perfrom
    });
    
    //dispatch_apply会阻塞，直到所有任务都完毕.
    //由此可见：假如把块派给了当前队列（或高于当前队列的串行队列），就将导致死锁.
    //若想在后台执行，则应使用dispatch group
}

#pragma mark - dispatch_get_global_queue参数

- (void)globalParams {
    /*参数
     1。涉及系统适配 ios 8 服务质量
     QOS_CLASS_USER_INTERACTIVE 用户交互（希望线程快速执行 不要放耗时操作）
     QOS_CLASS_USER_INITIATED 用户需要的 （不要放耗时操作）
     QOS_CLASS_DEFAULT 默认
     QOS_CLASS_UTILITY 使用工具 可以耗时操作
     QOS_CLASS_BACKGROUND 后台
     QOS_CLASS_UNSPECIFIED 没有指定优先级
     
     ios 7
     DISPATCH_QUEUE_PRIORITY_HIGH 2 高优先级
     DISPATCH_QUEUE_PRIORITY_DEFAULT 0 默认优先级
     DISPATCH_QUEUE_PRIORITY_LOW (-2) 低优先级
     DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN 后台优先级
     
     2.保留参数
     
     不要选择后台优先级 线程会非常慢
     */
    
    dispatch_queue_t q = dispatch_queue_create(0, 0);//0 默认
}

@end
