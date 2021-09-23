//
//  NSTimer+TimerBlocksSupport.h
//  demo
//
//  Created by lw on 17/3/28.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (BlocksSupport)
+ (NSTimer *)v_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats;
@end
