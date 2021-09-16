//
//  NSTimer+TimerBlocksSupport.m
//  demo
//
//  Created by lw on 17/3/28.
//  Copyright © 2017年 lee. All rights reserved.
/*
    将任务封装成块，调用函数时作为userinfo参数传进去，只要计时器有效就会保留参数
    copy block到堆上，防止稍后执行时，该块可能已经无效了
    计时器的target是NSTimer类对象，是个单例，因此计时器是否保留它都无所谓。此处依然有保留环，然而因为类对象无须回收，所以不用担心。
 */

#import "NSTimer+BlocksSupport.h"

@implementation NSTimer (BlocksSupport)
+ (NSTimer *)v_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats {

    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(v_blockInvoke:) userInfo:[block copy] repeats:YES];
}

+ (void)v_blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}
@end
