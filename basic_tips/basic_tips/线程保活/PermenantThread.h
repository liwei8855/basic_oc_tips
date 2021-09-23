//
//  PermenantThread.h
//  basic_tips
//
//  Created by 李威 on 2021/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface PermenantThread : NSObject
- (void)executeTask:(dispatch_block_t)task;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
