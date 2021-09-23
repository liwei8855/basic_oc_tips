//
//  PermenantThread.m
//  basic_tips
//
//  Created by 李威 on 2021/9/23.
//

#import "PermenantThread.h"
#import "LiveThread.h"
@interface PermenantThread()
@property (nonatomic, strong) LiveThread *innterThread;
@property (nonatomic, assign) BOOL threadStopped;

@end
@implementation PermenantThread

- (instancetype)init {
    if (self = [super init]) {
        self.threadStopped = NO;
        __weak typeof(self) weakSelf = self;
        self.innterThread = [[LiveThread alloc] initWithBlock:^{
            //NSRunLoop实现
//            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc]init] forMode:NSDefaultRunLoopMode];
//            while (weakSelf && !weakSelf.threadStopped) {
//                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//            }
            
            
            //--------------------
            //CFRunLoop实现
            // 创建上下文（要初始化一下结构体）
            CFRunLoopSourceContext context = {0};
            // 创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            // 往Runloop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            // 销毁source
            CFRelease(source);
            // 启动
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
            NSLog(@"end---");
        }];
        [self.innterThread start];
    }
    return self;
}

- (void)dealloc {
    [self stop];
}

- (void)executeTask:(dispatch_block_t)task {
    if (!self.innterThread || !task) {
        return;
    }
    [self performSelector:@selector(innerExecuteTask:) onThread:self.innterThread withObject:task waitUntilDone:NO];
}

- (void)stop {
    if (!self.innterThread) {
        return;
    }
    [self performSelector:@selector(innerStop) onThread:self.innterThread withObject:nil waitUntilDone:YES];
}

- (void)innerExecuteTask:(dispatch_block_t)task {
    task();
}

- (void)innerStop {
    self.threadStopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innterThread = nil;
}

@end
