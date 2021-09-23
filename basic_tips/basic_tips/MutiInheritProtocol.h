//
//  MutiInheritProtocol.h
//  demo
//
//  Created by 李威 on 2021/9/16.
//  Copyright © 2021 lee. All rights reserved.
/*
 消息转发机制+Protocol实现多继承
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MutiInheritAProtocol <NSObject>
- (void)goToSchool;
@end

@protocol MutiInheritBProtocol <NSObject>
- (void)goHome;
@end

NS_ASSUME_NONNULL_END
