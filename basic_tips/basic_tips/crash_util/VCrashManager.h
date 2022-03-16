//
//  VCrashManager.h
//  basic_tips
//
//  Created by 李威 on 2022/3/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, GuardType) {
    GuardTypeNone                 = 0,
    GuardTypeAll                  = 0xffff,
    GuardTypeContainer            = 1 << 0
};

@interface VCrashManager : NSObject
+ (instancetype)manager;
- (void)configCrashGuardService:(GuardType)guardType;
@end

NS_ASSUME_NONNULL_END
