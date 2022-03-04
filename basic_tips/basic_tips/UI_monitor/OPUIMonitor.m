//
//  OPUIMonitor.m
//  OPCategories
//
//  Created by 李威 on 2020/8/5.
//  Copyright © 2020 Opera Software. All rights reserved.
//

#import "OPUIMonitor.h"
//CFRunLoopObserverCallBack

static CFRunLoopActivity runLoopActivity;
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    runLoopActivity = activity;
//    NSLog(@"%@",info);
}
@implementation OPUIMonitor

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    static OPUIMonitor *monitor;
    dispatch_once(&onceToken, ^{
        monitor = [OPUIMonitor new];
    });
    return monitor;
}

- (void)startObserver {
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    CFRunLoopObserverRef runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities,YES,0,&runLoopObserverCallBack,&context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block int timeoutCount = 0;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            long st = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
            if (st != 0) {
                if (!runLoopObserver) {
                    timeoutCount = 0;
                    runLoopActivity = 0;
                    return;
                }
                if (runLoopActivity == kCFRunLoopBeforeSources || runLoopActivity==kCFRunLoopAfterWaiting) {
                    if (++timeoutCount < 5) {
                        continue;
                    }
                    NSLog(@"卡顿");
                }
            }
            timeoutCount = 0;
        }
    });
}

@end
