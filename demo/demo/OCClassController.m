//
//  OCClassController.m
//  demo
//
//  Created by lee on 2018/6/11.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "OCClassController.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import <CoreFoundation/CoreFoundation.h>

@interface OCClassController ()
@property (strong, nonnull) NSThread *thread;
@property (assign, nonatomic) BOOL isStop;//runloop停止标记
@end

@implementation OCClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSObject *obj = [[NSObject alloc] init];
    
    //获得NSObject类的实例对象的大小
    // 8
    //源码：返回成员变量的大小
    NSLog(@"%zd", class_getInstanceSize([NSObject class]));
    
    //获得obj指针指向内存的大小
    // 16
    NSLog(@"%zd", malloc_size((__bridge const void *)obj));
    
    //总结：分类了16字节，利用了8个
    
    
}

#pragma mark - runloop

- (void)addRunloopObserver {
    //创建observer
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observeRunLoopActicities, NULL);
    //添加observer到runloop
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    //释放
    CFRelease(observer);
    
//    //block方式
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//        //处理监听：observeRunLoopActicities中代码
//    });
//    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
//    CFRelease(observer);
    
}

void observeRunLoopActicities(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:{
            NSLog(@"kCFRunLoopEntry");
            break;
        }
        case kCFRunLoopBeforeTimers:{
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
        }
        case kCFRunLoopBeforeSources:{
            NSLog(@"kCFRunLoopBeforeSources");
            break;
        }
        case kCFRunLoopBeforeWaiting:{
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
        }
        case kCFRunLoopAfterWaiting:{
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
        }
        case kCFRunLoopAllActivities:{
            NSLog(@"kCFRunLoopAllActivities");
            break;
        }
        case kCFRunLoopExit:{
            NSLog(@"kCFRunLoopExit");
            break;
        }
        default:
        break;
    }
}

#pragma mark - 线程保活

- (void)keepThread {
    self.isStop = NO;
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.thread start];
}

- (void)run {
    
    NSLog(@"%@",[NSThread currentThread]);
    //runloop中没有任何source0/source1/timer/observer，runloop会立马退出
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
///run方法是无法停止的 此方法开启用不销毁的线程 所以后续需要停止线程 就要自己实现run方法
    ///run方法不断调用runMode:方法 停止只是停止了循环调用中的一次runMode方法
    //    [[NSRunLoop currentRunLoop] run];
    
    while (!self.isStop) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSLog(@"end----------");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
    NSLog(@"123");
}

- (void)test {
    NSLog(@"%s-----%@",__func__,[NSThread currentThread]);
}

/// 防止循环引用 停止子线程runloop

//dealloc在主线程执行，在主线程停止runloop停止的是主线程的runloop
//要停止子线程runloop就的在子线程停止
- (void)dealloc {
    [self performSelector:@selector(stop) onThread:self.thread withObject:nil waitUntilDone:NO];
    _thread = nil;
}

//子线程停止runloop
- (void)stop {
    self.isStop = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
}

@end
