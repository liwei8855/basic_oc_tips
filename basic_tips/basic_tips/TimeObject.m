//
//  TimeObject.m
//  demo
//
//  Created by lw on 17/3/28.
//  Copyright © 2017年 lee. All rights reserved.
/*
    weak引用打破保留环
 */

#import "TimeObject.h"

@implementation TimeObject {
    NSTimer *_pollTimer;
}

- (instancetype)init {
    return [super init];
}

- (void)dealloc {
    [_pollTimer invalidate];
}

- (void)stopPolling {
    [_pollTimer invalidate];
    _pollTimer = nil;
}

- (void)startPolling {
    __weak TimeObject *weakSelf = self;
    //self不被计时器保留，打破循环引用
    _pollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:weakSelf selector:@selector(p_doPoll) userInfo:nil repeats:YES];
}

- (void)p_doPoll {

}

@end
