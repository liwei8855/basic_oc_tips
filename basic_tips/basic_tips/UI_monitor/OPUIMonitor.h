//
//  OPUIMonitor.h
//  OPCategories
//
//  Created by 李威 on 2020/8/5.
//  Copyright © 2020 Opera Software. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OPUIMonitor : NSObject
+ (instancetype)instance;
- (void)startObserver;
@end

NS_ASSUME_NONNULL_END
