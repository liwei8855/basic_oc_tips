//
//  NSObject+GuardKVO.h
//  basic_tips
//
//  Created by 李威 on 2022/3/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class KVOProxy;
@interface NSObject (GuardKVO)
@property (nonatomic, strong, readonly) KVOProxy *kvoProxy;
@end

NS_ASSUME_NONNULL_END
